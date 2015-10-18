# 用户会话 - 密码登录

## HTTP 访问
BASE: /m/sessions/

PATH: 

METHOD: POST

HEADER: application/x-protobuf

VERSION: 1.0.0


## 参数列表


### 参数 - userName

* 必须: NO
* 来源: Client
* 类型: String
* 默认: N/A

### 参数 - password

* 必须: NO
* 来源: Client
* 类型: String
* 默认: N/A



## 输出数据结构

[com.argo.security.UserIdentity](/apidoc/proto/com.argo.security.UserIdentity "com.argo.security.UserIdentity实体")
