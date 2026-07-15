---
title: ai-doc
date: 2026-07-06 17:23:24
categories: 全栈
tags: 全栈
description: 从前端跨入全栈，最核心的坎在于理解服务端状态管理、数据库I/O、异步任务以及前后端鉴权。最适合练手的项目既不能太流于形式（比如简单的Todo List），也不能太庞大导致烂尾。为你推荐一个非常符合你技术背景、且极具含金量的练手项目：“双栏式 AI 协作智能文档/网盘系统”。这个项目既能发挥你已有的前端优势，又能完整帮你补齐后端的全盘知识。
---

## 双栏式 AI 协作智能文档/网盘系统(未结束持续更新中)

前端：React + TypeScript + TailwindCSS

后端：NestJS（首选，企业级架构，彻底弄懂什么是 IoC 注入、中间件、守卫、MVC 架构）或 Express / Fastify（轻量，适合速成）

数据库：PostgreSQL（关系型数据库，必学） + Prisma（现代 ORM，TypeScript 体验极佳，前端转型神兵利器），为了快速开发后端，我们借助一款可视化工具DBeaver [官网下载](https://dbeaver.io/download/)

AI 对接：OpenAI / DeepSeek / Gemini SDK

```text
ai-doc-backend/
├── prisma/                  # Prisma 专用目录
│   ├── schema.prisma        # 🚀 数据库建模文件（核心）
│   └── migrations/          # 数据库迁移历史记录
├── src/                     # 源代码目录
│   ├── common/              # 全局通用库/公共模块
│   │   ├── filters/         # 全局异常过滤器（处理报错响应）
│   │   └── interceptors/    # 全局拦截器（如统一返回格式）
│   ├── prisma/              # Prisma 模块（将其封装为 NestJS 服务）
│   │   ├── prisma.module.ts
│   │   └── prisma.service.ts
│   ├── auth/                # 鉴权模块（登录、JWT 验证）
│   │   ├── auth.module.ts
│   │   ├── auth.service.ts
│   │   └── auth.controller.ts
│   ├── document/            # 文档模块（业务内聚的典型代表）
│   │   ├── dto/             # 数据传输对象（校验前端输入）
│   │   │   ├── create-document.dto.ts
│   │   │   └── update-document.dto.ts
│   │   ├── entities/        # 实体定义（可选）
│   │   ├── document.controller.ts # 路由控制器（处理 HTTP 请求）
│   │   ├── document.service.ts    # 业务逻辑层（调用 Prisma 操作数据）
│   │   └── document.module.ts     # 模块声明
│   ├── app.module.ts        # 根模块（组装所有子模块）
│   └── main.ts              # 🚀 项目入口文件（启动服务）
├── .env                     # 环境变量（配置数据库连接串、JWT 密钥）
├── package.json
└── tsconfig.json
```

<!-- more -->

## 初始化项目数据库和后端项目

### 1. 全局安装 NestJS 脚手架（如果你以前没装过）
```
npm i -g @nestjs/cli
```

### 2. 创建后端项目（我们给后端起名叫 ai-doc-backend）
```
nest new ai-doc-backend
cd ai-doc-backend
npm run start:dev
```

打开浏览器访问 http://localhost:3000，看到 "Hello World!" 就说明 NestJS 已经成功跑起来了！Ctrl + C 先暂停服务。

### 3. 引入 Prisma 与配置数据库
```
# 1. 安装 Prisma 开发依赖
npm install prisma --save-dev

# 2. 初始化 Prisma 配置
npx prisma init
```
执行完 npx prisma init 后，你的项目根目录下会自动多出两个关键文件：

prisma/schema.prisma（数据库建模文件）

.env（环境变量配置文件）

如果本地是首次安装数据库，默认最高权限，没有密码，如果想设置通过
```
# 打开你的 Mac 终端，输入以下命令进入数据库管理界面
psql -d postgres
```
(此时你的终端提示符会变成 postgres=#，代表你已经成功进去了。)
在里面复制并运行下面这行 SQL 语句（把 你的新密码 换成你想设的密码，比如 123456，注意两边的单引号不要漏掉）：

```
ALTER USER xxx WITH PASSWORD '你的新密码';
```

当看到屏幕上回显 ALTER ROLE 时，说明密码已经成功刻进数据库里了！

输入 \q 然后回车，退出数据库命令行，回到你原本的 Mac 终端。

#### 手动启动与关闭数据库

##### macOS

Mac 上通过 Homebrew 安装的 PostgreSQL，常用以下命令：

```
# 启动数据库（后台常驻，开机可自动运行）
brew services start postgresql@14

# 关闭数据库
brew services stop postgresql@14

# 重启数据库
brew services restart postgresql@14

# 查看运行状态
brew services list
```

> 说明：`postgresql@14` 中的版本号按你实际安装的为准，可用 `brew list | grep postgres` 查看。若安装时未带版本号，命令改为 `brew services start postgresql` 即可。

如果只想临时启动、不注册为系统服务，可以用：

```
# 启动（前台运行，关闭终端即停止）
pg_ctl -D /opt/homebrew/var/postgresql@14 start

# 关闭
pg_ctl -D /opt/homebrew/var/postgresql@14 stop
```

> Intel 芯片 Mac 的数据目录一般在 `/usr/local/var/postgresql@14`，Apple 芯片在 `/opt/homebrew/var/postgresql@14`。

##### Windows

通过 [PostgreSQL 官方安装包](https://www.postgresql.org/download/windows/) 安装时，默认会注册为 Windows 服务。以**管理员身份**打开 CMD 或 PowerShell：

```
# 启动数据库
net start postgresql-x64-14

# 关闭数据库
net stop postgresql-x64-14

# 查看服务状态
sc query postgresql-x64-14
```

> 说明：服务名中的版本号以你安装的为准，常见为 `postgresql-x64-14`、`postgresql-x64-16` 等。可在「服务」管理界面中查看：按 `Win + R`，输入 `services.msc`，找到名称以 `postgresql` 开头的服务。

也可以用图形界面操作：打开 `services.msc` → 找到 PostgreSQL 服务 → 右键「启动」或「停止」。

如果需要用命令行手动控制数据目录（路径按实际安装位置修改）：

```
cd "C:\Program Files\PostgreSQL\14\bin"

# 启动
pg_ctl -D "C:\Program Files\PostgreSQL\14\data" start

# 关闭
pg_ctl -D "C:\Program Files\PostgreSQL\14\data" stop
```

##### 验证是否启动成功

macOS / Windows 均可执行（Windows 需确保 PostgreSQL 的 `bin` 目录已加入环境变量 PATH）：

```
psql -d postgres -c "SELECT version();"
```

能正常输出版本信息，说明数据库已在运行。

#### 修改.env 文件
```
# 在 Next.js 的 .env 中加入这行
# 端口依然是 5432，用户名 zhilan，密码写你刚才设好的那个
DATABASE_URL="postgresql://zhilan:你的新密码@localhost:5432/DATABASE?schema=public"
```
+ USER: 你的数据库用户名
+ PASSWORD: 数据库用户的密码
+ PORT: 数据库服务器运行的端口（通常5432用于 PostgreSQL）
+ DATABASE: 数据库名称
+ SCHEMA: 数据库中schema的名称

#### 创建数据库
psql -h localhost -p 5432 -U zhilan -d postgres -c "CREATE DATABASE DATABASE;"

#### 创建Document表
```text
model Document {
  id        String   @id @default(cuid())
  title     String
  content   String   @default("")
  createdAt DateTime @default(now())
  updatedAt DateTime @updatedAt
}
```
执行 pnpm exec prisma migrate dev --name init 生成表

验证表是否创建成功
```
psql -h localhost -p 5432 -U zhilan -d ai_doc_db -c "\dt"
```
看到 Document 表
```
         List of relations
 Schema |   Name   | Type  | Owner
--------+----------+-------+-------
 public | Document | table | zhilan
```
### 把 Prisma 接入 NestJS

数据库和表已经就绪，但 NestJS 还不会自动使用 Prisma。接下来我们要把 Prisma 封装成 NestJS 的**可注入服务**（IoC 容器里的单例），这样 `DocumentService` 等业务层就能通过构造函数注入来操作数据库，而不是到处 `new PrismaClient()`。

整体思路：

```text
HTTP 请求 → Controller → Service → PrismaService → PostgreSQL
```

#### 1. 安装 Prisma Client 并生成类型

Prisma 7 起推荐安装 PostgreSQL 驱动适配器（`@prisma/adapter-pg` + `pg`），否则启动时容易报 `PrismaClientInitializationError`：

```
npm install @prisma/client @prisma/adapter-pg pg
npm install -D @types/pg
npx prisma generate
```

`prisma generate` 会根据 `schema.prisma` 生成类型安全的客户端，之后写 `this.prisma.document.create(...)` 时，IDE 会有完整的自动补全。

#### 2. 创建 PrismaService

用脚手架生成模块目录：

```
nest g module prisma
nest g service prisma --no-spec
```

编辑 `src/prisma/prisma.service.ts`：

```typescript
import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  constructor() {
    const adapter = new PrismaPg({
      connectionString: process.env.DATABASE_URL as string,
    });
    // Prisma 7 要求构造时传入 adapter，不能空参 new PrismaClient()
    super({ adapter });
  }

  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
```

**要点：**
- 继承 `PrismaClient`，整个应用只维护一个数据库连接池
- 构造函数里通过 `PrismaPg` adapter 传入 `DATABASE_URL`
- `onModuleInit`：NestJS 启动时自动连库
- `onModuleDestroy`：应用关闭时优雅断开连接

#### 3. 创建 PrismaModule 并设为全局模块

编辑 `src/prisma/prisma.module.ts`：

```typescript
import { Global, Module } from '@nestjs/common';
import { PrismaService } from './prisma.service';

@Global()
@Module({
  providers: [PrismaService],
  exports: [PrismaService],
})
export class PrismaModule {}
```

`@Global()` 表示注册一次后，所有业务模块都能直接注入 `PrismaService`，不必在每个 Module 里重复 `imports: [PrismaModule]`。

#### 4. 注册到根模块

编辑 `src/app.module.ts`：

```typescript
import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { PrismaModule } from './prisma/prisma.module';
import { DocumentModule } from './document/document.module';

@Module({
  imports: [PrismaModule, DocumentModule],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
```

#### 5. 创建 Document 业务模块

用 NestJS 脚手架一键生成 CRUD 骨架：

```
// 如果已经全局安装过 @nestjs/cli
npx nest g resource 表名
// 如果全局未安装
nest g resource document --no-spec
```

CLI 会问通信风格，选 **REST API**，会自动创建 `controller`、`service`、`module` 和 `dto` 目录。

安装请求体校验依赖：

```
npm install class-validator class-transformer
```

在 `src/main.ts` 中开启全局校验：

```typescript
import { ValidationPipe } from '@nestjs/common';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  app.useGlobalPipes(new ValidationPipe({ whitelist: true }));
  app.enableShutdownHooks();
  await app.listen(3000);
}
bootstrap();
```

编辑 `src/document/dto/create-document.dto.ts`：

```typescript
import { IsNotEmpty, IsOptional, IsString } from 'class-validator';

export class CreateDocumentDto {
  @IsString()
  @IsNotEmpty()
  title: string;

  @IsString()
  @IsOptional()
  content?: string;
}
```

编辑 `src/document/dto/update-document.dto.ts`：

```typescript
import { PartialType } from '@nestjs/mapped-types';
import { CreateDocumentDto } from './create-document.dto';

export class UpdateDocumentDto extends PartialType(CreateDocumentDto) {}
```

编辑 `src/document/document.service.ts`，注入 `PrismaService` 实现 CRUD：

```typescript
import { Injectable, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateDocumentDto } from './dto/create-document.dto';
import { UpdateDocumentDto } from './dto/update-document.dto';

@Injectable()
export class DocumentService {
  constructor(private readonly prisma: PrismaService) {}

  create(dto: CreateDocumentDto) {
    return this.prisma.document.create({ data: {
      title: dto.title,
      content: dto.content ?? '',
    } });
  }

  findAll() {
    return this.prisma.document.findMany({
      orderBy: { updatedAt: 'desc' },
    });
  }

  async findOne(id: string) {
    const doc = await this.prisma.document.findUnique({ where: { id } });
    if (!doc) throw new NotFoundException(`Document #${id} not found`);
    return doc;
  }

  async update(id: string, dto: UpdateDocumentDto) {
    await this.findOne(id);
    return this.prisma.document.update({ where: { id }, data: dto });
  }

  async remove(id: string) {
    await this.findOne(id);
    return this.prisma.document.delete({ where: { id } });
  }
}
```

`DocumentController` 脚手架已自动生成路由，无需额外修改，默认暴露以下接口：

| 方法 | 路径 | 说明 |
| --- | --- | --- |
| POST | `/document` | 创建文档 |
| GET | `/document` | 获取全部文档 |
| GET | `/document/:id` | 获取单篇文档 |
| PATCH | `/document/:id` | 更新文档 |
| DELETE | `/document/:id` | 删除文档 |

#### 6. 启动并验证

```
npm run start:dev
```

##### 启动时报错怎么排查

**报错 1：模块格式不匹配 / 找不到生成产物**

检查 `prisma/schema.prisma`，把 `generator client` 改成：

```
generator client {
  provider     = "prisma-client"
  output       = "../generated/prisma"
  moduleFormat = "cjs"  // 强制生成 CommonJS，和 NestJS 默认模块格式匹配
}
```

改完后重新生成：

```
npx prisma generate
```

如果 `PrismaService` 仍从 `@prisma/client` 导入失败，可改为从生成目录导入（路径按你的 `output` 调整）：

```typescript
import { PrismaClient } from '../../generated/prisma/client';
```

**报错 2：`PrismaClientInitializationError`**

```
PrismaClient needs to be constructed with a non-empty, valid PrismaClientOptions
```

这是 Prisma 7 的常见坑：新版 `prisma-client` generator 默认走「无 engine + driver adapter」，**不能再空参 `new PrismaClient()`**，必须在构造时传入 adapter。

解决步骤：

1. 安装适配器依赖（若尚未安装）：

```
npm install @prisma/adapter-pg pg
npm install -D @types/pg
```

2. 修改 `src/prisma/prisma.service.ts`，在 `super()` 中传入 adapter：

```typescript
import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';
// 若自定义了 output，改为：
// import { PrismaClient } from '../../generated/prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';

@Injectable()
export class PrismaService
  extends PrismaClient
  implements OnModuleInit, OnModuleDestroy
{
  constructor() {
    const adapter = new PrismaPg({
      connectionString: process.env.DATABASE_URL as string,
    });
    super({ adapter });
  }

  async onModuleInit() {
    await this.$connect();
  }

  async onModuleDestroy() {
    await this.$disconnect();
  }
}
```

3. 确认 `.env` 里有非空的 `DATABASE_URL`，且 NestJS 启动时能读到它（可在 `AppModule` 中启用 `ConfigModule.forRoot()`，或保证项目根目录存在 `.env`）。

4. 再次生成并启动：

```
npx prisma generate
npm run start:dev
```

> 核心原因：Prisma 7 要求 `PrismaClient` 带着有效的 `PrismaClientOptions`（至少要有 `adapter` 或 `accelerateUrl`）才能初始化；空构造会直接抛出上面的 `PrismaClientInitializationError`。

**创建一篇文档：**

```
curl -X POST http://localhost:3000/document \
  -H "Content-Type: application/json" \
  -d '{"title":"第一篇文档","content":"Hello Prisma + NestJS"}'
```

**查询全部文档：**

```
curl http://localhost:3000/document
```

若返回 JSON 数组且包含刚创建的文档，说明 Prisma 已成功接入 NestJS，整条链路打通：

```text
curl → DocumentController → DocumentService → PrismaService → PostgreSQL
```

也可以在 DBeaver 中刷新 `Document` 表，直接看到写入的数据。

> **常见问题：**
> - 若新增了一个模型，要重新执行npx prisma generate
> - 若报 `Cannot find module '@prisma/client'`，先执行 `npx prisma generate`；自定义了 `output` 时，改为从 `generated/prisma/client` 导入。
> - 若报 `PrismaClient needs to be constructed with a non-empty, valid PrismaClientOptions`，在 `PrismaService` 构造函数里通过 `@prisma/adapter-pg` 传入 `adapter`（见上文「启动时报错怎么排查」）。
> - 若报数据库连接失败，检查 `.env` 中的 `DATABASE_URL` 是否正确，以及 PostgreSQL 是否处于 `started` 状态（`brew services list`）。
