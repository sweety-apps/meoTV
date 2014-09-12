/**
 * Created by test2 on 14-9-11.
 */
var mongodb = require('./db');
function Verifycode(code) {
    this.phone = code.phone;
    this.isVerify = code.isVerify;
};
module.exports = Verifycode;
Verifycode.prototype.save = function save(callback) { // 存入 Mongodb 的文档

    var verifycode = {
        phone: this.phone,
        isVerify: this.isVerify
    };
    mongodb.open(function(err, db) { if (err) {
        return callback(err);
    }
        db.collection('verifycodes', function(err, collection) {
            if (err) {
                mongodb.close();
                return callback(err);
            }
            collection.ensureIndex('phone', {unique: true});
            collection.insert(verifycode, {safe: true}, function(err, verifycode) {

                mongodb.close();
                callback(err, verifycode);
            });

        });
    });
};

Verifycode.get = function get(phone, callback) {
    mongodb.open(function(err, db) {
        if (err) {
            return callback(err);
        }
        db.collection('verifycodes', function(err, collection) {
            if (err) {
                mongodb.close();
                return callback(err);
            }
            collection.findOne({phone: phone}, function(err, doc) {
                mongodb.close();
                if (doc) {
                    var verifycode = new Verifycode(doc);
                    callback(err, verifycode);
                } else {
                    callback(err, null);
                }
            });
        });
    });
};