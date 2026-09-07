# 实验室综合管理系统

一套面向高校实验室的**综合数字化管理平台**，采用「前后端分离 + 科技可视化」架构，覆盖实验室信息、实验室预约、设备预约、设备借用、设备归还、设备报修、设备采购、实验室耗材、危化品标准库、废弃物审核验收与处置、诚信评分、综合数据统计等全流程业务，助力实验室高效、规范、安全运行。

> 系统界面采用**深空蓝黑 + 霓虹青紫**的科技风设计，含玻璃态卡片、网格背景、发光边框与实时数据图表，界面整洁、风格统一。

---

## 一、技术栈

| 层次 | 技术选型 |
| --- | --- |
| 后端 | Spring Boot 2.7.14、MyBatis、MySQL 8、JWT（jjwt）、BCrypt（spring-security-crypto）、Lombok、JUnit 5 |
| 前端 | 原生 HTML5 / CSS3 / JavaScript、ECharts 5 可视化、SVG 图标、无构建依赖（静态直跑） |
| 鉴权 | JWT Token 无状态鉴权 + `@RequireRole` 注解式角色权限控制 |
| 数据库 | MySQL 8（库名 `lab_equipment`，utf8mb4） |

## 二、功能清单

### 通用
- 账号登录（JWT）、账号注册、退出登录
- 个人中心：资料修改、密码修改
- 诚信评分：默认 100 分，逾期/损失设备扣分，低于 60 分禁止借用

### 实验教学闭环（新增）
- 班级管理与学生归班：班级、年级、专业、院系、辅导员和学生关联
- 实验项目库：课程、学时、教学目标、安全事项和报告模板
- 实验安排：班级、实验室、教师与时段联合排课，自动校验实验室/教师时间冲突
- 学生考勤：学生自主签到，教师登记出勤、缺勤和迟到
- 实验报告：学生在线提交/覆盖更新，教师按 0–100 分批改并填写评语
- 成绩归档：学生仅查看本人报告和成绩，教师仅查看本人授课报告，管理员全局查看

### 资产运维增强（新增）
- 供应商档案：联系人、业务范围、评分与启停状态
- 预防性维护：周期计划、到期/逾期识别、维护过程、结果、费用和下一维护日自动滚动

### 学生端（STUDENT，含教师 TEACHER）
- 首页概览：可用设备、借用中、待审批、待处理报修统计 + 最新公告 + 最近动态
- 设备信息：设备照片 + 品牌/型号/详细规格卡片展示，在线申请借用（含诚信分校验）
- 我的申请 / 借用记录：查看审批进度与归还历史
- 设备报修：提交报修工单、跟踪维修进度
- 实验室信息：实验室照片 + 类型/位置/容量卡片展示
- 实验室预约：在线预约实验室（含时段冲突校验）
- 设备预约：在线预约设备使用时段
- 设备采购申请：提交设备采购需求
- 我的收藏：收藏实验室与设备，统一管理
- 我的诚信分：查看诚信评分与变更记录
- 反馈建议：提交建议/投诉/咨询，查看管理员回复
- 公告通知：查看系统公告

### 实验员端（LAB_ADMIN）
- 工作台：待审批借用、待处理报修、借用中设备统计 + 最近待批申请
- 借用审批、借还登记、逾期管理、设备管理、报修工单、公告管理
- 实验室预约审核、设备预约审核、采购审核

### 超级管理员端（ADMIN / 系主任）
- 综合统计面板：实验室使用率、设备使用率等可视化图表
- 借用审批、借用记录、逾期管理、设备管理（含图片/品牌/规格）、报修处理、公告管理
- 用户管理：用户增删改查、角色分配、冻结/解冻、密码重置
- 实验室管理：实验室信息维护（含类型、图片）
- 实验室类型：实验室类型分类维护
- 实验室预约审核、设备预约审核、采购管理
- 实验室耗材管理：耗材增删改查
- 危化品标准库：危化品信息维护
- 废弃物管理：废弃物登记、审核验收、处置
- 诚信管理：诚信评分调整与记录查看
- 反馈建议：查看并回复用户反馈

## 三、角色体系

| 角色 | role_code | 说明 |
| --- | --- | --- |
| 学生 | STUDENT | 借用/预约设备、预约实验室、报修、采购申请 |
| 教师 | TEACHER | 同学生权限 |
| 实验员 | LAB_ADMIN | 审批、借还、报修处理、设备/实验室管理、预约审核 |
| 管理员 | ADMIN | 全部权限 + 用户/耗材/危化品/废弃物/诚信管理 |
| 系主任 | DEPARTMENT_HEAD | 同管理员权限 |

## 四、诚信评分机制

- 初始诚信分：100 分；
- 逾期归还：扣 10 分；
- 设备损失：扣 30 分（设备自动报废）；
- 借用门槛：诚信分 < 60 分时禁止借用设备；
- 管理员可在「诚信管理」中手动调整分数，所有变更留痕。

## 四、目录结构

```
d:/web
├── 01_数据库脚本
│   └── lab_equipment_init.sql          # 一键初始化脚本（建库建表 + 全部数据）
├── 02_后端工程 lab-reserve-server（Spring Boot + MyBatis）
│   └── src/main/java/com/lab/reserve
│       ├── controller/   # 接口层（含设备可用性/我的记录/逾期管理）
│       ├── service/      # 业务层
│       ├── mapper/       # MyBatis 数据访问
│       ├── entity/       # 实体
│       ├── dto/          # 传输对象
│       ├── common/       # JWT / 密码 / 上下文等公共组件
│       ├── config/       # 拦截器、跨域、全局异常
│       ├── annotation/   # @RequireRole 注解
│       └── util/         # 统一返回结果
├── 03_前端工程完整代码
│   ├── login.html           # 登录/注册页
│   ├── board_student.html   # 学生端
│   ├── board_lab.html       # 实验员端
│   ├── board_admin.html     # 管理员端
│   └── assets
│       ├── app.css          # 科技风设计系统
│       └── api.js           # 请求封装与工具
├── database
│   ├── lab_equipment_init.sql   # 初始化脚本（与 01_数据库脚本 同源）
│   ├── datas/                   # 原始数据集（8 个 CSV）
│   └── migrations/              # 索引优化脚本
└── README.md
```

## 五、运行步骤

### 1. 初始化数据库
使用 MySQL 8 执行一键初始化脚本（含建表 + 全部演示数据）：

```sql
source 01_数据库脚本/lab_equipment_init.sql;
-- 或
mysql -u root -p < 01_数据库脚本/lab_equipment_init.sql
mysql -u root -p lab_equipment < 01_数据库脚本/02_academic_asset_upgrade.sql
```

> 该脚本由 `database/datas/` 下的 8 个 CSV 真实数据集自动生成，包含：5 个角色、38+ 用户、12 个设备分类、80 台设备、120 条借用申请、43 条借用记录、123 条报修记录、35 条公告，以及 5 个实验室、3 条实验室预约、3 条设备预约、3 条采购单、5 条耗材、5 条危化品、3 条废弃物记录。

### 2. 配置并启动后端
开发环境可使用默认连接；推荐通过环境变量配置数据库：

```yaml
DB_URL=jdbc:mysql://localhost:3306/lab_equipment
DB_USERNAME=root
DB_PASSWORD=你的数据库密码
```

**方式一（开发环境，推荐）**：使用 IDEA 导入 `02_后端工程 lab-reserve-server` 工程，运行 `LabReserveApplication` 启动类，服务监听 `http://localhost:8080`。

**方式二（上线部署）**：在工程目录执行 Maven 打包，生成可执行 jar：

```bash
mvn clean package -DskipTests
java -jar target/lab-reserve-server-1.0.0.jar
```

### 3. 打开前端

> 前端为纯静态页面，推荐通过本地 HTTP 服务访问（避免 `file://` 协议下的跨域与存储限制）。

```bash
# 在 03_前端工程完整代码 目录下启动静态服务器
cd 03_前端工程完整代码
python -m http.server 5173
```

然后浏览器访问 `http://localhost:5173/login.html`。

登录任一角色工作台后，点击右下角“实验教学管理”进入教学与资产运维中心。

### 4. 容器化部署（上线前验收环境）

先完成后端打包，再从 `deploy` 目录启动：

```bash
mvn clean package
cd deploy
cp .env.example .env
# 修改 .env 中全部密码、JWT 密钥和学校正式域名
docker compose up -d --build
```

此模板提供前后端同源反向代理、非 root 后端进程、MySQL 持久化、健康检查和安全响应头。生产环境仍必须由学校完成 HTTPS、备份恢复、等保/隐私审查、统一身份认证和压力测试。

> 如开发环境后端地址非 `http://localhost:8080`，可在浏览器控制台执行
> `localStorage.setItem('apiBase', 'http://你的后端地址')` 后刷新页面。

### 5. 测试账号

| 账号 | 密码 | 角色 |
| --- | --- | --- |
| admin | 123456 | 超级管理员 |
| lab | 123456 | 实验员 |
| student | 123456 | 学生 |
| student001 | 123456 | 学生 |
| teacher001 | 123456 | 教师 |
| lab001 | 123456 | 实验员 |
| admin001 | 123456 | 管理员 |

## 六、核心接口一览

| 模块 | 方法 | 路径 | 权限 |
| --- | --- | --- | --- |
| 认证 | POST | `/api/auth/login` | 公开 |
| 认证 | POST | `/api/auth/register` | 公开 |
| 个人 | GET/PUT | `/api/profile` | 登录 |
| 个人 | PUT | `/api/profile/password` | 登录 |
| 设备 | GET | `/api/devices` | 登录 |
| 设备 | GET | `/api/devices/{id}/availability` | 登录 |
| 设备 | POST/PUT | `/api/devices` | 实验员/管理员 |
| 设备 | DELETE | `/api/devices/{id}` | 管理员 |
| 分类 | GET | `/api/categories` | 登录 |
| 借用 | POST | `/api/borrow/apply` | 登录 |
| 借用 | GET | `/api/borrow/applies` | 登录 |
| 借用 | POST | `/api/borrow/approve` | 实验员/管理员 |
| 借用 | GET | `/api/borrow/records` | 登录 |
| 借用 | POST | `/api/borrow/return` | 实验员/管理员 |
| 我的 | GET | `/api/my/applies` | 登录 |
| 我的 | GET | `/api/my/records` | 登录 |
| 我的 | GET | `/api/my/repairs` | 登录 |
| 逾期 | POST | `/api/overdue/refresh` | 实验员/管理员 |
| 逾期 | GET | `/api/overdue/records` | 实验员/管理员 |
| 报修 | POST | `/api/repairs/report` | 登录 |
| 报修 | GET | `/api/repairs` | 登录 |
| 报修 | POST | `/api/repairs/handle` | 实验员/管理员 |
| 公告 | GET | `/api/notices` | 登录 |
| 公告 | POST/DELETE | `/api/notices` | 管理员 |
| 用户 | GET/POST/PUT | `/api/users` | 管理员 |
| 用户 | PUT | `/api/users/{id}/status` | 管理员 |
| 统计 | GET | `/api/stats/overview` | 实验员/管理员 |
| 实验室 | GET/POST/PUT/DELETE | `/api/labs` | 登录/管理员 |
| 实验室预约 | GET/POST | `/api/labs/reservations` | 登录 |
| 实验室预约 | POST | `/api/labs/reservations/audit` | 实验员/管理员 |
| 设备预约 | GET/POST | `/api/device-reservations` | 登录 |
| 设备预约 | POST | `/api/device-reservations/audit` | 实验员/管理员 |
| 采购 | GET/POST | `/api/purchases` | 登录 |
| 采购 | POST | `/api/purchases/audit` | 管理员 |
| 耗材 | GET/POST/PUT/DELETE | `/api/consumables` | 管理员 |
| 危化品 | GET/POST/PUT/DELETE | `/api/chemicals` | 管理员 |
| 废弃物 | GET/POST | `/api/wastes` | 登录 |
| 废弃物 | POST | `/api/wastes/audit` `/api/wastes/dispose` | 管理员 |
| 诚信 | GET | `/api/credit/my` | 登录 |
| 诚信 | GET/POST | `/api/credit/logs` `/api/credit/adjust` | 管理员 |
| 损失 | POST | `/api/borrow/loss` | 实验员/管理员 |
| 综合统计 | GET | `/api/dashboard/overview` | 实验员/管理员 |
