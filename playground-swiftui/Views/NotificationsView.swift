//
//  NotificationsView.swift
//  playground-swiftui
//
//  Created by June Ha on 2023-08-21.
//

import SwiftUI

struct NotificationsScreen: View {
    @State private var notifications = NOTIFICATIONS
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(notifications) { notification in
                    NotificationView(notification: notification)
                        .swipeActions(edge: .leading) {
                            if notification.isUnread {
                                Button {
                                    if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
                                        notifications[index].isUnread = false
                                    }
                                } label: {
                                    Label("Mark as read", systemImage: "envelope.open")
                                }
                                .tint(.blue)
                            }
                        }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Notifications")
            .toolbar {
                Button {
                    notifications.enumerated().forEach({
                        if $1.isUnread {
                            notifications[$0].isUnread = false
                        }
                    })
                } label: {
                    Text("Mark as all read")
                        .font(.callout)
                }
                .disabled(notifications.allSatisfy({ !$0.isUnread }))
            }
        }
    }
}

struct NotificationView: View {
    let notification: Notification
    
    private var Post: Text {
        return Text("\(notification.user.name) ").bold() +
            Text("\(notification.status.action) ").foregroundColor(.gray) +
            Text(notification.status.post).bold()
        
    }
    
    var body: some View {
        HStack {
            HStack(alignment: .top) {
                Image(notification.user.avatar)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .padding(.trailing, 4)
                
                VStack(alignment: .leading) {
                    Post.font(.caption)
                    Text(notification.timeAgo)
                        .foregroundColor(.gray)
                        .font(.caption2)
                        .padding(.top, 1)
                    
                    if notification.user.name == "Ricky Fowler" {
                        Text("Hello, thanks for setting up the Chess Club. I've been a member for a few weeks now and I'm already having lots of fun and improving my game!")
                            .font(.caption2)
                            .padding(8)
                            .overlay(RoundedRectangle(cornerRadius: 4).stroke())
                            .foregroundColor(.gray)
                    }
                }
            }
            
            Spacer()
            if notification.isUnread {
                Color.blue
                    .frame(width: 10, height: 10)
                    .clipShape(Circle())
            }
        }
        .padding(.vertical, 2)
    }
}

struct Notification: Identifiable {
    let id = UUID()
    let user: User
    let status: Status
    let timeAgo: String
    var isUnread: Bool
}

struct User: Identifiable {
    let id = UUID()
    let avatar: String
    let name: String
}

struct Status {
    let post: String
    let action: String
}

struct NotificationsScreen_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsScreen()
    }
}

let NOTIFICATIONS: [Notification] = [
    .init(user: User(avatar: "victor", name: "Mark Webber"),
          status: Status(post: "My first tournament today!", action: "reacted to your recent post"),
          timeAgo: "1m ago",
          isUnread: true
         ),
    .init(user: User(avatar: "victor", name: "Angela Gray"),
          status: Status(post: "", action: "followed you"),
          timeAgo: "5m ago",
          isUnread: true
         ),
    .init(user: User(avatar: "victor", name: "Jacob Thompson"),
          status: Status(post: "Chess club", action: "has joined your group"),
          timeAgo: "1 day ago",
          isUnread: true
         ),
    .init(user: User(avatar: "victor", name: "Ricky Fowler"),
          status: Status(post: "", action: "sent you a private message"),
          timeAgo: "5 days ago",
          isUnread: false
         ),
    .init(user: User(avatar: "victor", name: "Kimberly Smith"),
          status: Status(post: "", action: "commented on your picture"),
          timeAgo: "1 week ago",
          isUnread: false
         ),
    .init(user: User(avatar: "victor", name: "Nathan Peterson"),
          status: Status(post: "5 end-game strategies to increase your win rate", action: "reacted to your recent post"),
          timeAgo: "2 weeks ago",
          isUnread: false
         ),
    .init(user: User(avatar: "victor", name: "Anna Kim"),
          status: Status(post: "Chess Club", action: "left the group"),
          timeAgo: "2 weeks ago",
          isUnread: false
         ),
    .init(user: User(avatar: "victor", name: "Magnus Carlson"),
          status: Status(post: "Chess Club", action: "joined the group"),
          timeAgo: "2 weeks ago",
          isUnread: false
         ),
    .init(user: User(avatar: "victor", name: "Jeremy Lin"),
          status: Status(post: "", action: "liked your message"),
          timeAgo: "2 weeks ago",
          isUnread: false
         ),
    .init(user: User(avatar: "victor", name: "Anna Kim"),
          status: Status(post: "Chess Club", action: "joined the group"),
          timeAgo: "4 weeks ago",
          isUnread: false
         ),
    .init(user: User(avatar: "victor", name: "Tay Mac"),
          status: Status(post: "", action: "reacted to your picture"),
          timeAgo: "5 weeks ago",
          isUnread: false
         ),
]
