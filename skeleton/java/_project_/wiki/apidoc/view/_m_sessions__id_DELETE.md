# 用户会话 - 退出登录

## HTTP 访问
BASE: /m/sessions/

PATH: {id}

METHOD: DELETE

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

[com.argo.web.protobuf.PAppResponse](/apidoc/proto/com.argo.web.protobuf.PAppResponse "com.argo.web.protobuf.PAppResponse实体")
