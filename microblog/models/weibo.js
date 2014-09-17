/**
 * Created by test2 on 14-9-8.
 */
var mongodb = require('./db');
function Weibo(weibo) {
    this.desc = weibo.desc;
    this.user = weibo.user;
    this.images = weibo.images;
    this.createTime = weibo.createTime;
};

module.exports = Weibo;
Weibo.prototype.save = function save(callback) { // 存入 Mongodb 的文档

    var weibo = {
        desc: this.desc,
        user: this.user,
        images: this.images,
        createTime :this.createTime
    };
    mongodb.open(function(err, db) { if (err) {
        return callback(err);
    }
        db.collection('weibos', function(err, collection) {
            if (err) {
                mongodb.close();
                return callback(err);
            }
            collection.insert(weibo, {safe: true}, function(err, weibo) {

                mongodb.close();
                callback(err, weibo);
            });

        });
    });
};

Weibo.get =  function get(from,to,callback) {
    mongodb.open(function(err, db) {
        if (err) {
            return callback(err);
        }
        db.collection('weibos', function(err, collection) {
            if (err) {
                mongodb.close();
                return callback(err);
            }
            collection.find().sort({'_id':-1}).limit(to).skip(from).toArray(function(err,result){
                callback(err,result);
            });
        });
    });
};