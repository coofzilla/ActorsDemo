//
//  MessageStore.swift
//  MessageStore
//
//  Created by Pedro Rojas on 21/07/21.
//

import Foundation

actor MessageStore {
    var messageHistory: [Message] = []
    let id = UUID()

    func newMessage(completion: @escaping (Message) async -> Void) async {
        NetworkMessager.shared.fetchMessage { [weak self] message in
            guard let self = self else { return }
            Task {
                await self.saveMessage(message)
                await completion(message)
            }
        }
    }

    func saveMessage(_ message: Message) {
        messageHistory.append(message)
    }

    func history() -> [Message] {
        messageHistory
    }
}

extension MessageStore: Equatable {
    static func == (lhs: MessageStore, rhs: MessageStore) -> Bool {
        return lhs.id == rhs.id
    }
}

extension MessageStore: Hashable {
    nonisolated func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    nonisolated var hashValue: Int {
        return id.hashValue
    }
}
