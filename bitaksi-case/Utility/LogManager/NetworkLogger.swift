//
//  NetworkLogger.swift
//  bitaksi-case
//
//  Created by Semih Özsoy on 16.04.2026.
//

import Foundation
import Alamofire

final class NetworkLogger: EventMonitor {

    let queue = DispatchQueue(label: "com.bitaksi.networklogger")

    // MARK: - Request

    func requestDidFinish(_ request: Request) {
        guard let urlRequest = request.request else { return }

        var log = "\n┌─── REQUEST ───────────────────────────────────\n"
        log += "│ \(urlRequest.httpMethod ?? "?") \(urlRequest.url?.absoluteString ?? "")\n"

        if let headers = urlRequest.allHTTPHeaderFields, !headers.isEmpty {
            log += "│ Headers:\n"
            headers.forEach { log += "│   \($0.key): \($0.value)\n" }
        }

        if let body = urlRequest.httpBody, let bodyString = prettyPrinted(body) {
            log += "│ Body:\n\(bodyString.indented())\n"
        }

        log += "└───────────────────────────────────────────────────"
        LogManager.info(log)
    }

    // MARK: - Response

    func request<Value>(_ request: DataRequest, didParseResponse response: DataResponse<Value, AFError>) {
        let statusCode = response.response?.statusCode ?? 0
        let isSuccess = (200...299).contains(statusCode)
        let icon = isSuccess ? "✅" : "❌"

        var log = "\n┌─── \(icon) RESPONSE ──────────────────────────────────\n"
        log += "│ \(statusCode) \(response.request?.url?.absoluteString ?? "")\n"
        log += "│ Duration: \(String(format: "%.3f", response.metrics?.taskInterval.duration ?? 0))s\n"

        if let headers = response.response?.allHeaderFields as? [String: String], !headers.isEmpty {
            log += "│ Headers:\n"
            headers.forEach { log += "│   \($0.key): \($0.value)\n" }
        }

        if let data = response.data, let bodyString = prettyPrinted(data) {
            log += "│ Body:\n\(bodyString.indented())\n"
        }

        if let error = response.error {
            log += "│ Error: \(error)\n"
        }

        log += "└───────────────────────────────────────────────────"

        if isSuccess {
            LogManager.info(log)
        } else {
            LogManager.error(log)
        }
    }

    // MARK: - Helpers

    private func prettyPrinted(_ data: Data) -> String? {
        guard !data.isEmpty else { return nil }
        if let json = try? JSONSerialization.jsonObject(with: data),
           let pretty = try? JSONSerialization.data(withJSONObject: json, options: .prettyPrinted) {
            return String(data: pretty, encoding: .utf8)
        }
        return String(data: data, encoding: .utf8)
    }
}

private extension String {
    func indented() -> String {
        split(separator: "\n", omittingEmptySubsequences: false)
            .map { "│   \($0)" }
            .joined(separator: "\n")
    }
}
