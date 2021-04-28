//
//  main.swift
//  FirstCourseFinalTask
//
//  Copyright © 2017 E-Legion. All rights reserved.
//

import Foundation
import FirstCourseFinalTaskChecker

typealias GenericIdentifier = FirstCourseFinalTaskChecker.GenericIdentifier

typealias UserInitialData = FirstCourseFinalTaskChecker.UserInitialData
typealias UserProtocol = FirstCourseFinalTaskChecker.UserProtocol
typealias UserID = GenericIdentifier<UserProtocol>
typealias Followers = [(UserID, UserID)]

typealias PostInitialData = FirstCourseFinalTaskChecker.PostInitialData
typealias PostProtocol = FirstCourseFinalTaskChecker.PostProtocol
typealias PostID = GenericIdentifier<PostProtocol>
typealias Likes = [(UserID, PostID)]

struct FollowersStorage {
    private var privateStorage: Followers
    init(followers: Followers) {
        privateStorage = followers
    }
    //на кого подписан userID
    func follows(_ userID: UserID) -> [UserID] {
        return privateStorage.filter{ $0.0 == userID }.map{ $0.1 }
    }
    //подписчики userID
    func followedBy(_ userID: UserID) -> [UserID] {
        return privateStorage.filter{ $0.1 == userID }.map{ $0.0 }
    } 
    //кол-во подписок userID
    func followsCount(_ userID: UserID) -> Int {
        return self.follows(userID).count
    }
    //кол-во подписчиков userID
    func followedByCount(_ userID: UserID) -> Int {
        return self.followedBy(userID).count
    }
    //подписан ли userID1 на userID2
    func isFollows(_ userID1: UserID, _ userID2: UserID) -> Bool {
        return self.follows(userID1).contains(where: { $0 == userID2 })
    }
    //подписать userID1 на userID2
    mutating func addFollows(_ userID1: UserID, _ userID2: UserID) {
        if !isFollows(userID1, userID2) {
            privateStorage.append((userID1, userID2))
        }
    }
    //отписать userID1 от userID2
    mutating func removeFollows(_ userID1: UserID, _ userID2: UserID) {
        if isFollows(userID1, userID2) {
            privateStorage = privateStorage.filter{ !($0.0 == userID1 && $0.1 == userID2) }
        }
    }
}


struct UserData: UserProtocol {
    init(userInitialData: UserInitialData, followersStorage: FollowersStorage, currentUserID: UserID) {
        id = userInitialData.id
        username = userInitialData.username
        fullName = userInitialData.fullName
        avatarURL = userInitialData.avatarURL
        currentUserFollowsThisUser = followersStorage.isFollows(currentUserID, id)
        currentUserIsFollowedByThisUser = followersStorage.isFollows(id, currentUserID)
        followsCount = followersStorage.followsCount(id)
        followedByCount = followersStorage.followedByCount(id)
    }
    var id: UserID
    var username: String
    var fullName: String
    var avatarURL: URL?
    /// Свойство, отображающее подписан ли текущий пользователь на этого пользователя
    var currentUserFollowsThisUser: Bool
    /// Свойство, отображающее подписан ли этот пользователь на текущего пользователя
    var currentUserIsFollowedByThisUser: Bool
    /// Количество подписок этого пользователя
    var followsCount: Int
    /// Количество подписчиков этого пользователя
    var followedByCount: Int
}

final class UsersStorageClass: UsersStorageProtocol {
    /// Инициализатор хранилища. Принимает на вход массив пользователей, массив подписок в
    /// виде кортежей в котором первый элемент это ID, а второй - ID пользователя на которого он
    /// должен быть подписан и ID текущего пользователя.
    /// Инициализация может завершится с ошибкой если пользователя с переданным ID
    /// нет среди пользователей в массиве users.
    init?(users: [UserInitialData], followers: [(UserID, UserID)], currentUserID: UserID) {
        guard users.contains(where: {$0.id == currentUserID}) else {
            return nil
        }
        self.currentUserID = currentUserID
        let flw = FollowersStorage(followers: followers)
        self.privateStorage = Dictionary(uniqueKeysWithValues: users.map{
            ($0.id,
             UserData(userInitialData: $0,
                      followersStorage: flw,
                      currentUserID: currentUserID))
        })
        self.followersStorage = flw
    }
    
    let currentUserID: UserID
    private var privateStorage: [UserID: UserData]
    var followersStorage: FollowersStorage

    /// Количество пользователей в хранилище.
    var count: Int {
        return privateStorage.count
    }

    /// Возвращает текущего пользователя.
    ///
    /// - Returns: Текущий пользователь.
    func currentUser() -> UserProtocol {
        return privateStorage[currentUserID]!
    }

    /// Возвращает пользователя с переданным ID.
    ///
    /// - Parameter userID: ID пользователя которого нужно вернуть.
    /// - Returns: Пользователь если он был найден.
    /// nil если такого пользователя нет в хранилище.
    func user(with userID: UserID) -> UserProtocol? {
        return privateStorage[userID]
    }

    /// Возвращает всех пользователей, содержащих переданную строку.
    ///
    /// - Parameter searchString: Строка для поиска.
    /// - Returns: Массив пользователей. Если не нашлось ни одного пользователя, то пустой массив.
    func findUsers(by searchString: String) -> [UserProtocol] {
        return privateStorage.filter{ $0.value.fullName.contains(searchString)
                                      || $0.value.username.contains(searchString) }
                             .map{ $0.value }
    }

    /// Добавляет текущего пользователя в подписчики.
    ///
    /// - Parameter userIDToFollow: ID пользователя на которого должен подписаться текущий пользователь.
    /// - Returns: true если текущий пользователь стал подписчиком пользователя с переданным ID
    /// или уже являлся им.
    /// false в случае если в хранилище нет пользователя с переданным ID.
    func follow(_ userIDToFollow: UserID) -> Bool {
         guard (privateStorage[userIDToFollow] != nil) else {
            return false
        }
        followersStorage.addFollows(currentUserID, userIDToFollow)
        privateStorage[userIDToFollow]?.followedByCount += 1
        privateStorage[currentUserID]?.followsCount += 1
        return true
    }
    
    /// Удаляет текущего пользователя из подписчиков.
    ///
    /// - Parameter userIDToUnfollow: ID пользователя от которого должен отписаться текущий пользователь.
    /// - Returns: true если текущий пользователь перестал быть подписчиком пользователя с
    /// переданным ID или и так не являлся им.
    /// false в случае если нет пользователя с переданным ID.
    func unfollow(_ userIDToUnfollow: UserID) -> Bool {
        guard (privateStorage[userIDToUnfollow] != nil) else {
            return false
        }
        followersStorage.removeFollows(currentUserID, userIDToUnfollow)
        privateStorage[userIDToUnfollow]?.followedByCount -= 1
        privateStorage[currentUserID]?.followsCount -= 1
        return true
    }
    
    /// Возвращает всех подписчиков пользователя.
    ///
    /// - Parameter userID: ID пользователя подписчиков которого нужно вернуть.
    /// - Returns: Массив пользователей.
    /// Пустой массив если на пользователя никто не подписан.
    /// nil если такого пользователя нет.
    func usersFollowingUser(with userID: UserID) -> [UserProtocol]? {
        guard (privateStorage[userID] != nil) else {
            return nil
        }
        let followedBy = followersStorage.followedBy(userID)
        return privateStorage.filter{ followedBy.contains($0.key)  }
                             .map{ $0.value }
    }

    /// Возвращает все подписки пользователя.
    ///
    /// - Parameter userID: ID пользователя подписки которого нужно вернуть.
    /// - Returns: Массив пользователей.
    /// Пустой массив если он ни на кого не подписан.
    /// nil если такого пользователя нет.
    func usersFollowedByUser(with userID: UserID) -> [UserProtocol]? {
        guard (privateStorage[userID] != nil) else {
            return nil
        }
        let follows = followersStorage.follows(userID)
        return privateStorage.filter{ follows.contains($0.key)  }
                             .map{ $0.value }
    }
}

struct PostData: PostProtocol {
    init(postInitialData: PostInitialData, currentUserLikesThisPost: Bool, likedByCount: Int) {
        id = postInitialData.id
        author = postInitialData.author
        description = postInitialData.description
        imageURL = postInitialData.imageURL
        createdTime = postInitialData.createdTime
        self.currentUserLikesThisPost = currentUserLikesThisPost
        self.likedByCount = likedByCount
        
    }
    var id: PostID
    var author: UserID
    var description: String
    var imageURL: URL
    var createdTime: Date
    /// Свойство, отображающее ставил ли текущий пользователь лайк на эту публикацию
    var currentUserLikesThisPost: Bool
    /// Количество лайков на этой публикации
    var likedByCount: Int
}

final class PostsStorageClass: PostsStorageProtocol {
    /// Инициализатор хранилища. Принимает на вход массив публикаций, массив лайков в виде
    /// кортежей в котором первый - это ID пользователя, поставившего лайк, а второй - ID публикации
    /// на которой должен стоять этот лайк и ID текущего пользователя.
    init(posts: [PostInitialData], likes: Likes, currentUserID: UserID) {
        self.currentUserID = currentUserID
        self.likes = likes
        self.privateStorage = Dictionary(uniqueKeysWithValues: posts.map{
            (postInitialData) in
            (postInitialData.id,
             PostData(postInitialData: postInitialData,
                      currentUserLikesThisPost: likes.contains{ (currentUserID, postInitialData.id) == $0 },
                      likedByCount: likes.filter{ postInitialData.id == $0.1 }.count ))
        })
    }

    let currentUserID: UserID
    private var privateStorage: [PostID: PostData]
    var likes: Likes

    /// Количество публикаций в хранилище.
    var count: Int {
        return privateStorage.count
    }

    /// Возвращает публикацию с переданным ID.
    ///
    /// - Parameter postID: ID публикации которую нужно вернуть.
    /// - Returns: Публикация если она была найдена.
    /// nil если такой публикации нет в хранилище.
    func post(with postID: PostID) -> PostProtocol? {
        return privateStorage[postID]
    }

    /// Возвращает все публикации пользователя с переданным ID.
    ///
    /// - Parameter authorID: ID пользователя публикации которого нужно вернуть.
    /// - Returns: Массив публикаций.
    /// Пустой массив если пользователь еще ничего не опубликовал.
    func findPosts(by authorID: UserID) -> [PostProtocol] {
        return privateStorage.filter{ $0.value.author == authorID}
                             .map{ $0.value }
    }

    /// Возвращает все публикации, содержащие переданную строку.
    ///
    /// - Parameter searchString: Строка для поиска.
    /// - Returns: Массив публикаций.
    /// Пустой массив если нет таких публикаций.
    func findPosts(by searchString: String) -> [PostProtocol] {
        return privateStorage.filter{ $0.value.description.contains(searchString) }
                             .map{ $0.value }
    }

    /// Ставит лайк от текущего пользователя на публикацию с переданным ID.
    ///
    /// - Parameter postID: ID публикации на которую нужно поставить лайк.
    /// - Returns: true если операция выполнена упешно или пользователь уже поставил лайк
    /// на эту публикацию.
    /// false в случае если такой публикации нет.
    func likePost(with postID: PostID) -> Bool {
        guard (privateStorage[postID] != nil) else {
            return false
        }
        if (!likes.contains{ $0.0 == currentUserID && $0.1 == postID }) {
            likes.append((currentUserID, postID))
            privateStorage[postID]?.currentUserLikesThisPost = true
            privateStorage[postID]?.likedByCount += 1
        }
        return true
    }

    /// Удаляет лайк текущего пользователя у публикации с переданным ID.
    ///
    /// - Parameter postID: ID публикации у которой нужно удалить лайк.
    /// - Returns: true если операция выполнена успешно или пользователь и так не ставил лайк
    /// на эту публикацию.
    /// false в случае если такой публикации нет.
    func unlikePost(with postID: PostID) -> Bool {
        guard (privateStorage[postID] != nil) else {
            return false
        }
        likes = likes.filter{ !($0.0 == currentUserID && $0.1 == postID) }
        privateStorage[postID]?.currentUserLikesThisPost = false
        privateStorage[postID]?.likedByCount -= 1
        return true
    }

    /// Возвращает ID пользователей поставивших лайк на публикацию.
    ///
    /// - Parameter postID: ID публикации лайки на которой нужно искать.
    /// - Returns: Массив ID пользователей.
    /// Пустой массив если никто еще не поставил лайк на эту публикацию.
    /// nil если такой публикации нет в хранилище.
    func usersLikedPost(with postID: PostID) -> [UserID]? {
        guard (privateStorage[postID] != nil) else {
            return nil
        }
        return likes.filter{ postID == $0.1 }
                    .map{ $0.0 }
    }
}

let checker = Checker(usersStorageClass: UsersStorageClass.self,
                      postsStorageClass: PostsStorageClass.self)
checker.run()

