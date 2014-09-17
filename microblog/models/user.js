/**
 * Created by test2 on 14-9-6.
 */
var mongodb = require('./db');
function User(user) {
    this.name = user.name;
    this.password = user.password;
    this.avatar = user.avatar;
    this.nickName = user.nickName;
};
module.exports = User;
User.prototype.save = function save(callback) { // 存入 Mongodb 的文档

    var user = {
        name: this.name,
        password: this.password,
        avatar: this.avatar,
        nickName: this.nickName
    };
    mongodb.open(function(err, db) { if (err) {
        return callback(err);
    }
        db.collection('users', function(err, collection) {
            if (err) {
                mongodb.close();
                return callback(err);
            }
            collection.ensureIndex('name', {unique: true});
            collection.insert(user, {safe: true}, function(err, user) {

                mongodb.close();
                callback(err, user);
            });

        });
    });
};
User.edit = function edit(username,avatar,callback){
    console.log(username);
    console.log(avatar);
    mongodb.open(function(err, db) {
        if (err) {
            return callback(err);
        }
        db.collection('users', function(err, collection) {
            if (err) {
                mongodb.close();
                return callback(err);
            }
            collection.findOne({name: username}, function(err, doc) {

                if (doc) {

                    collection.update({name: username},{$set:{avatar: avatar}}, {safe:true},function(err,obj){
                        mongodb.close();
                        callback(err, obj);
                    });
                } else {
                    callback(err, null);
                }
            });

        });
    });
};

User.get = function get(username, callback) {
    mongodb.open(function(err, db) {
        if (err) {
            return callback(err);
        }
        db.collection('users', function(err, collection) {
            if (err) {
                mongodb.close();
                return callback(err);
            }
            collection.findOne({name: username}, function(err, doc) {
                mongodb.close();
                if (doc) {
                    var user = new User(doc);
                    callback(err, user);
                } else {
                    callback(err, null);
                }
            });
       });
   });
};
