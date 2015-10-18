# 用户会话 - 自动登录

## HTTP 访问
BASE: /m/sessions/

PATH: {id}

METHOD: PUT

HEADER: application/x-protobuf

VERSION: 1.0.0


## 参数列表


### 参数 - id

用户id

* 必须: YES
* 来源: Path
* 类型: Long
* 默认: N/A



## 输出数据结构

[com.argo.security.UserIdentity](/apidoc/proto/com.argo.security.UserIdentity "com.argo.security.UserIdentity实体")
