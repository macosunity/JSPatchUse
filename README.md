![JSPatchUse](https://img.shields.io/badge/build-passing-green.svg)
![JSPatchUse](https://img.shields.io/badge/LICENSE-MIT-brightgreen.svg)

# JSPatchUse
 JSPatch 代码更新 使用学习


*****************
# 使用方法


### 步骤1：创建项目中导入JSPatch库

        切换到项目命令：
        cd /Users/..(项目地址)

        编辑或创建Podfile命令：
        vim Podfile

        【编辑内容添加：
        platform :ios, '6.0'
        pod 'JSPatch'
        粘贴后按“esc”，输入“：”，再输入“wq”】

        安装命令：
        pod install


### 步骤2：添加demo.js 文件到项目，修改AppDelegate.m文件：

        #import "JPEngine.h"
        
        - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

        [JPEngine startEngine];
        NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"demo" ofType:@"js"];
        NSString *script = [NSString stringWithContentsOfFile:sourcePath encoding:NSUTF8StringEncoding error:nil];
        [JPEngine evaluateScript:script];

        return YES;
        }

### 步骤3：修复控制器的崩溃bug：

   ##### 控制器ViewController添加按钮，但是不写点击事件

        UIButton *crashBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 50)];
        [crashBtn setTitle:@"崩溃按钮" forState:UIControlStateNormal];
        [crashBtn addTarget:self action:@selector(crashBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [crashBtn setBackgroundColor:[UIColor grayColor]];
        [self.view addSubview:crashBtn];


        //崩溃按钮 的点击事件【崩溃测试，不写】，js里会重写此方法避免崩溃。
        //- (void)crashBtnClick:(id)sender.


   #####  demo.js里添加代码：1、重写crashBtnClick方法 2、跳转新建的JPTableViewController控制器

        //1、修改ViewController控制器的handleBtn方法（原控制器漏此方法，会导致崩溃）。

        defineClass('ViewController', {//defineClass：声明要被修改的控制器
        crashBtnClick: function(sender) { //声明要被修改或重写的方法
        var tableViewCtrl = JPTableViewController.alloc().init()
        self.navigationController().pushViewController_animated(tableViewCtrl, YES)
        },

        })

        //2、新建JPTableViewController控制器

        defineClass('JPTableViewController : UITableViewController <UIAlertViewDelegate>', ['data'], {
        dataSource: function() {
        var data = self.data();
        if (data) return data;
        var data = [];
        for (var i = 0; i < 20; i ++) {
        data.push("通过js创建的cell " + i);
        }
        self.setData(data)
        return data;
        },
        numberOfSectionsInTableView: function(tableView) {
        return 1;
        },
        tableView_numberOfRowsInSection: function(tableView, section) {
        return self.dataSource().length;
        },
        tableView_cellForRowAtIndexPath: function(tableView, indexPath) {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") 
        if (!cell) {
        cell = require('UITableViewCell').alloc().initWithStyle_reuseIdentifier(0, "cell")
        }
        cell.textLabel().setText(self.dataSource()[indexPath.row()])
        return cell
        },
        tableView_heightForRowAtIndexPath: function(tableView, indexPath) {
        return 60
        },
        tableView_didSelectRowAtIndexPath: function(tableView, indexPath) {
        var alertView = require('UIAlertView').alloc().initWithTitle_message_delegate_cancelButtonTitle_otherButtonTitles("Alert",self.dataSource()[indexPath.row()], self, "OK",  null);
        alertView.show()
        },
        alertView_willDismissWithButtonIndex: function(alertView, idx) {
        console.log('click btn ' + alertView.buttonTitleAtIndex(idx).toJS())
        }
        })


*****************
      至此JSPatch在前端设置和使用差不多了。
*****************

### 步骤4：通过请求后台更新项目中demo.js补丁文件来达到动态修复项目Bug的功能。demo.js从后台下载后要加密存储到沙盒中。


    #####  demo.js的加密：
        在使用JSPatch时，JS脚本理论上可以调用任意OC方法，权限非常大，若经过HTTP传输时，被中间人攻击篡改js代码，则会造成很大危害。

        鉴于此种情况

            1. 服务器尽量使用https传输
            2. 对传输的代码做好加密和校验

PHP、iOS 使用JSPatch基本与RSA,AES加密：
http://www.jianshu.com/p/e6191c9e63c1


