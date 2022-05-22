//
//  QuestionAnswerModel.swift
//  ToDoAssistant
//
//  Adapted from Julien Chaumond CoreMLBert project:
//  https://github.com/huggingface/swift-coreml-transformers/blob/master/Sources/BertForQuestionAnswering.swift
//

import Foundation
import NaturalLanguage
import CoreML

struct QuestionAnswer {
    let startIndex: Int
    let endIndex: Int
    let tokens: [String]

    var answer: String? {
        guard tokens.count > endIndex, endIndex > startIndex else {
            return nil
        }
        return tokens[startIndex...endIndex]
                     .joined(separator: GlobalConstants.emptyString)
    }
}

final class QuestionAnswerModel {
    private let model: BERTQAFP16

    init() throws {
        model = try BERTQAFP16(configuration: .init())
    }

    /// Finds an answer to a given question by searching a document's text.
    ///
    /// - parameters:
    ///     - question: The user's question about a document.
    ///     - document: The document text that (should) contain an answer.
    /// - returns: The answer string or an error descripton.
    /// - Tag: FindAnswerForQuestionInDocument
    func predict(question: String, context: String) throws -> Substring {
        // Prepare the input for the BERT model.
        let bertInput = BERTInput(documentString: context, questionString: question)

        guard bertInput.totalTokenSize <= BERTInput.maxTokens else {
            var message = "Text and question are too long"
            message += " (\(bertInput.totalTokenSize) tokens)"
            message += " for the BERT model's \(BERTInput.maxTokens) token limit."
            return Substring(message)
        }

        // The MLFeatureProvider that supplies the BERT model with its input MLMultiArrays.

        // Make a prediction with the BERT model.
        guard let modelInput: BERTQAFP16Input = bertInput.modelInput,
              let prediction = try? model.prediction(input: modelInput) else {
                  throw GeneralError(message: "The BERT model is unable to make a prediction.",
                                     errorCode: NSKeyValueValidationError)
        }

        // Analyze the output form the BERT model.
        guard let bestLogitIndices = bestLogitsIndices(from: prediction,
                                                       in: bertInput.documentRange) else {
            return "Couldn't find a valid answer. Please try again."
        }

        // Find the indices of the original string.
        let documentTokens = bertInput.document.tokens
        let answerStart = documentTokens[bestLogitIndices.start].startIndex
        let answerEnd = documentTokens[bestLogitIndices.end].endIndex

        // Return the portion of the original string as the answer.
        let originalText = bertInput.document.original
        return originalText[answerStart..<answerEnd]
    }
}

// MARK: - Private

private extension QuestionAnswerModel {
    /// Finds the indices of the best start logit and end logit given a prediction output and a range.
    ///
    /// - parameters:
    ///     - prediction: A feature provider that supplies the output MLMultiArrays from a BERT model.
    ///     - range: A range of the output tokens to search.
    /// - returns: Description.
    /// - Tag: BestLogitIndices
    func bestLogitsIndices(from prediction: BERTQAFP16Output, in range: Range<Int>) -> (start: Int, end: Int)? {
        // Convert the logits MLMultiArrays to [Double].
        let startLogits = prediction.startLogits.doubleArray()
        let endLogits = prediction.endLogits.doubleArray()

        // Isolate the logits for the document.
        let startLogitsOfDoc = [Double](startLogits[range])
        let endLogitsOfDoc = [Double](endLogits[range])

        // Only keep the top 20 (out of the possible ~380) indices for faster searching.
        let topStartIndices = startLogitsOfDoc.indicesOfLargest(20)
        let topEndIndices = endLogitsOfDoc.indicesOfLargest(20)

        // Search for the highest valued logit pairing.
        let bestPair = findBestLogitPair(startLogits: startLogitsOfDoc,
                                         bestStartIndices: topStartIndices,
                                         endLogits: endLogitsOfDoc,
                                         bestEndIndices: topEndIndices)

        guard bestPair.start >= 0 && bestPair.end >= 0 else {
            return nil
        }

        return bestPair
    }

    /// Searches the given indices for the highest valued start and end logits.
    ///
    /// - parameters:
    ///     - startLogits: An array of all the start logits.
    ///     - bestStartIndices: An array of the best start logit indices.
    ///     - endLogits: An array of all the end logits.
    ///     - bestEndIndices: An array of the best end logit indices.
    /// - returns: A tuple of the best start index and best end index.
    func findBestLogitPair(startLogits: [Double],
                           bestStartIndices: [Int],
                           endLogits: [Double],
                           bestEndIndices: [Int]) -> (start: Int, end: Int) {

        let logitsCount = startLogits.count
        var bestSum = -Double.infinity
        var bestStart = -1
        var bestEnd = -1

        for start in 0..<logitsCount where bestStartIndices.contains(start) {
            for end in start..<logitsCount where bestEndIndices.contains(end) {
                let logitSum = startLogits[start] + endLogits[end]

                if logitSum > bestSum {
                    bestSum = logitSum
                    bestStart = start
                    bestEnd = end
                }
            }
        }
        return (bestStart, bestEnd)
    }
}

