var express = require('express');
var router = express.Router();
var User = require('../models/user.js');
var Weibo = require('../models/weibo.js');

var Verifycode = require('../models/verifycode.js');

var formidable = require('formidable');
var crypto = require('crypto');

var gm = require('gm');
var fs = require('fs');
var imageMagick = gm.subClass({ imageMagick : true });
var images = require("images");
/* GET home page. */
router.post('/reg',function(req,res){

    Verifycode.get(req.body.username,function (err,verificode) {
        if(!verificode){
            console.log("xxxx");
            res.json({'retcode':'-1','desc':'手机没有验证','data':{}});
            return;
        }

        var newUser = new User({
            name: req.body.username,
            password: req.body.password,
            avatar: 'http://192.168.1.117:3000/images/default.jpg',
            nickName: req.body.nickName
        });
        User.get(newUser.name, function(err, user) {
            if (user)
                err = 'Username already exists.'+user.name;
            if (err) {
                //req.flash('error', err);
                res.send(JSON.stringify({"desc":"用户存在"}));
                return;
            }
            newUser.save(function(err) {
                if (err) {
                    res.send(JSON.stringify({"desc":"error"}));
                }
                res.json({"desc":"success"});
            });
        });
    });

});
router.post('/setVcode',function(req,res){

    console.log(req.body.phone);


    Verifycode.get(req.body.phone,function(err,verifycode){

        console.log(verifycode);
        if (verifycode) {
            //req.flash('error', err);
            res.json(({"desc":"用户存在",'retcode':'0'}));
            return;
        }
        var verifycode = new Verifycode({
            phone: req.body.phone,
            isVerify: req.body.isVerify
        });
        verifycode.save(function(err,verifycode){
            if (err) {
                res.json({"desc":"error",'retcode':'-1'});
                return;
            }
            res.json({"desc":"success",'retcode':'0'});
        });
    });

});
router.post('/fetchweibo',function(req,res){
   Weibo.get(parseInt(req.body.datafrom),parseInt(req.body.dataend),function(err,weibos){
       if(weibos)
       {
           res.json({'retcode':'0','data':{'weibos':weibos}});
       }else
       {
           res.json({'retcode':'0','data':{}});
       }
   });
});
router.post('/isUserExist',function(req,res){
    User.get(req.body.username, function(err, user) {
        if (user){
            res.json({'retcode':'0','desc':'用户存在'});//用户不存在
        }else
        {
            res.json({'retcode':'-1','desc':'用户不存在'});//用户不存在
        }
    });
});
function jiami(data)
{

    var crypto = require('crypto');
    var data = "156156165152165156156";
    var algorithm = 'aes-256-ecb';
    var key = 'ksdsz1528ksdsz1528ksdsz152811122';
    var clearEncoding = 'utf8';
    var iv = "";
    var cipherEncoding = 'base64';
    var cipherChunks = data.split("");
    var decipher = crypto.createDecipheriv(algorithm, key,iv);
    var plainChunks = [];
    for (var i = 0;i < cipherChunks.length;i++) {
        plainChunks.push(decipher.update(cipherChunks[i], cipherEncoding, clearEncoding));
    }
    plainChunks.push(decipher.final(clearEncoding));
    return plainChunks.join('');


}
router.post('/login',function(req,res){
    User.get(req.body.username, function(err, user) {
        if (user){
            try{
                if(user.name === req.session.user.name)
                {
                    res.json({'retcode':'0','data':{},'desc':'用户已经登录'});
                }
            }catch(e)
            {
                if(user.password === req.body.password)
                {
                    crypto.randomBytes(48, function(ex, buf) {
                        var token = buf.toString('hex');
                        req.session.user = user;
                        res.json({'retcode':'0','data':{'token':req.session.token,'user':user}});
                    });

                }else
                {
                    res.json({'retcode':'-2','desc':'密码错误'}); //密码不对
                }
            }

        }else
        {
            res.json({'retcode':'-1','desc':'用户不存在'});//用户不存在
        }
    });
});
router.post('/createweibo',function(req,res){
    req.on('error', function (e) {
        console.log('Problem with request: ' + e.message);
    });
    if(!req.session.user)
    {
        res.json({'retcode':'-1','desc':'未登录','data':{}});
        return;
    }else
    {
        var fileDirectory = './public/images/',
            form = new formidable.IncomingForm();
        form.keepExtensions = true;
        form.uploadDir = fileDirectory;
        form.parse(req, function (err, fields, files) {
            if (err) throw (err);
            var image = [];
            var i = 0;
            for(var key in files) {
                var path = files[key]['path'].split('/');
                images("./public/images/"+path[2])                     //加载图像文件
                    .size(160)                          //等比缩放图像到400像素宽
                    .save("./public/images/"+path[2].split('.')[0]+"_160_160.jpg", {               //保存图片到文件,图片质量为50
                        quality : 50
                    });
                var url = 'http://192.168.1.117:3000/' + path[1]+'/'+path[2].split('.')[0]+'_160_160.jpg';
                image[i] = url;
                i++;
            }
            var newWeibo = new Weibo({
                desc: fields['content'],
                user: req.session.user,
                images: image,
                createTime :fields['createTime']
            });
            newWeibo.save(function(err){

            if (err) {
                res.json({'retcode':'-1','desc':'error','error':err});
            }
            res.json({'retcode':'0',"desc":"success",'data':{'weibo':newWeibo}});
        });


        });
    }
});

router.post('/upload',function(req,res){
    req.on('error', function (e) {
        console.log('Problem with request: ' + e.message);
    });
    if(!req.session.user)
    {
        res.json({'retcode':'-1','desc':'未登录','data':{}});
        return;
    }else
    {
        var fileDirectory = './public/images/',
            form = new formidable.IncomingForm();
        form.keepExtensions = true;
        form.uploadDir = fileDirectory;
        form.parse(req, function (err, fields, files) {
            console.log(files);
            if (err) throw (err);
            for(var key in files) {

                var size = parseInt(files[key]['size']);
                if(size > 1024*1024){//大于1M
                    fs.unlink(files[key]['path'], function() {    //fs.unlink 删除用户上传的文件
                    });
                    res.json({'path':'','retcode':'-1','desc':'文件过大'});
                    return;
                }
                var path = files[key]['path'].split('/');

                images("./public/images/"+path[2])                     //加载图像文件
                    .size(160)                          //等比缩放图像到400像素宽
                    .save("./public/images/"+path[2].split('.')[0]+"_160_160.jpg", {               //保存图片到文件,图片质量为50
                        quality : 50
                    });
                User.edit(req.session.user.name,'http://192.168.1.117:3000/' + path[1]+'/'+path[2],function(err,obj){
                    res.json({'path':'http://192.168.1.117:3000/' + path[1]+'/'+path[2]});
                });
                break;
            }
        });
    }
});

module.exports = router;
