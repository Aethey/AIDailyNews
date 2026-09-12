# AI Daily News 埋点要求

## 1. 目标

本项目使用 Firebase Analytics 收集用户的**自然阅读行为**，用于后续分析资讯偏好，并优化每日新闻的筛选与排序。

核心原则：

- 不要求用户评分
- 不要求用户点赞 / 点踩
- 不要求用户收藏
- 不要求用户分享
- 不增加任何“为了学习偏好”而设计的交互
- 只记录用户正常使用 App 时自然产生的行为
- 偏好由后台根据行为自动推断

用户只需要正常：

```text
打开 App
→ 浏览新闻
→ 点开文章
→ 阅读
→ 返回
→ 阅读原文
```

系统在后台自动学习。

---

# 2. 技术方案

使用：

```text
Flutter
↓
firebase_analytics
↓
Firebase Analytics
```

依赖：

```yaml
dependencies:
  firebase_core:
  firebase_analytics:
```

埋点统一通过：

```dart
FirebaseAnalytics.instance.logEvent(...)
```

发送。

---

# 3. 文章必须具有稳定 ID

每篇新闻必须有一个长期稳定、唯一的：

```text
article_id
```

推荐格式：

```text
YYYYMMDD-source-slug
```

例如：

```text
20260912-openai-agents-api
```

同一篇新闻：

- GitHub JSON 中使用相同 `article_id`
- Flutter App 使用相同 `article_id`
- Firebase Analytics 使用相同 `article_id`

不要使用：

```text
List index
随机 UUID
当前排序位置
```

作为文章 ID。

---

# 4. 文章 Metadata 要求

新闻数据中建议至少保留：

```json
{
  "id": "20260912-openai-agents-api",
  "title": "Introducing the Agents API",
  "source": "OpenAI",
  "topics": [
    "agent",
    "api",
    "developer"
  ],
  "published_at": "2026-09-12",
  "estimated_read_minutes": 5,
  "url": "https://..."
}
```

用于偏好分析的主要字段：

```text
article_id
source
topics
published_at
estimated_read_minutes
```

其中：

```text
topics
```

非常重要。

推荐一个文章可以拥有多个 topic。

例如：

```json
"topics": [
  "agent",
  "developer_tools",
  "api"
]
```

---

# 5. 必须实现的埋点

第一版实现以下 5 个被动事件：

```text
article_impression
article_open
article_read
original_link_click
article_reopen
```

其中核心事件是：

```text
article_impression
article_open
article_read
```

---

# 6. article_impression

## 含义

新闻卡片真正进入用户可视区域。

不是：

```text
新闻数据被加载
```

而是：

```text
用户实际上有机会看到这条新闻
```

这是判断“用户是否主动跳过某类新闻”的基础。

---

## 触发条件

建议：

```text
新闻卡片至少 50% 进入可视区域
```

并持续：

```text
>= 500ms
```

才记录一次 impression。

---

## 同一次页面浏览中不要重复上报

例如用户：

```text
向下滚动
→ 新闻 A 出现
→ 向上滚动
→ 新闻 A 再次出现
```

本次 Feed Session 中只记录一次：

```text
article_impression
```

---

## 参数

```text
article_id
position
feed_date
```

示例：

```dart
await FirebaseAnalytics.instance.logEvent(
  name: 'article_impression',
  parameters: {
    'article_id': article.id,
    'position': index,
    'feed_date': '2026-09-12',
  },
);
```

---

# 7. article_open

## 含义

用户自然点击新闻卡片，进入文章详情。

---

## 触发时机

进入文章详情页时立即记录。

---

## 参数

```text
article_id
position
feed_date
```

示例：

```dart
await FirebaseAnalytics.instance.logEvent(
  name: 'article_open',
  parameters: {
    'article_id': article.id,
    'position': index,
    'feed_date': '2026-09-12',
  },
);
```

---

# 8. article_read

## 含义

记录一次真实阅读 Session。

这是偏好分析中最重要的事件。

---

## 不要每秒发送事件

禁止这种方式：

```text
1 秒
→ event

2 秒
→ event

3 秒
→ event
```

会产生大量无意义事件。

应该在用户离开文章详情页时汇总一次。

---

## 需要统计

文章详情页打开后，本地维护：

```text
进入时间
当前是否前台可见
最大滚动深度
```

用户：

```text
返回 Feed
切换文章
关闭详情
```

时发送一次：

```text
article_read
```

---

## 参数

```text
article_id
reading_time_sec
max_scroll_percent
```

示例：

```dart
await FirebaseAnalytics.instance.logEvent(
  name: 'article_read',
  parameters: {
    'article_id': article.id,
    'reading_time_sec': 183,
    'max_scroll_percent': 92,
  },
);
```

---

# 9. reading_time_sec 计算要求

只统计：

```text
文章详情页处于可见状态
+
App 处于前台
```

的时间。

不应该把这些情况计入阅读时间：

```text
App 进入后台
用户切到其他 App
屏幕锁定
页面已经被其他页面覆盖
```

例如：

```text
打开文章 5 分钟
其中切到微信 3 分钟
```

应该记录大约：

```text
reading_time_sec = 120
```

而不是：

```text
300
```

---

# 10. max_scroll_percent

记录用户本次阅读过程中到达过的最大滚动深度。

范围：

```text
0 ~ 100
```

例如：

```text
0
20
45
82
100
```

只需要最后发送最大值。

例如：

```text
用户先滚到 80%
然后返回 40%
最后退出
```

记录：

```text
max_scroll_percent = 80
```

---

# 11. original_link_click

## 含义

用户点击文章本来就存在的：

```text
阅读原文
```

这不是为了收集反馈新增的按钮。

它属于自然产品行为，因此可以作为强兴趣信号。

---

## 参数

```text
article_id
```

示例：

```dart
await FirebaseAnalytics.instance.logEvent(
  name: 'original_link_click',
  parameters: {
    'article_id': article.id,
  },
);
```

---

# 12. article_reopen

## 含义

用户在已经阅读过某篇文章后，再次打开它。

重复打开通常是一个很强的兴趣信号。

---

## 判断方式

本地记录：

```text
article_id 是否已经打开过
```

如果已经存在，再次进入文章：

```text
article_reopen
```

---

## 参数

```text
article_id
```

示例：

```dart
await FirebaseAnalytics.instance.logEvent(
  name: 'article_reopen',
  parameters: {
    'article_id': article.id,
  },
);
```

---

# 13. 禁止添加的反馈型事件

为了保持完全无感学习，第一版不要为了推荐系统新增：

```text
article_like
article_dislike
article_rating
article_favorite
article_not_interested
article_feedback
```

也不要新增 UI：

```text
👍
👎
1~5 星
“对我有用”
“不感兴趣”
“减少此类内容”
```

偏好必须主要从自然行为推断。

---

# 14. 第一版事件表

| Event | 触发 | 主要参数 | 重要度 |
|---|---|---|---|
| `article_impression` | 新闻真正进入可视区域 | `article_id`, `position`, `feed_date` | 必须 |
| `article_open` | 点击进入详情 | `article_id`, `position`, `feed_date` | 必须 |
| `article_read` | 离开文章详情时 | `article_id`, `reading_time_sec`, `max_scroll_percent` | 必须 |
| `original_link_click` | 点击阅读原文 | `article_id` | 推荐 |
| `article_reopen` | 再次打开读过的文章 | `article_id` | 推荐 |

---

# 15. 不需要自己埋的基础事件

Firebase Analytics 本身会自动采集部分基础事件和 Session 信息。

因此不要为了“事件多一点”重复制造大量自定义事件。

我们的重点是：

```text
看到什么
↓
点了什么
↓
真正读了多久
↓
读到了哪里
↓
是否继续阅读原文
↓
是否再次回来阅读
```

---

# 16. 兴趣判断逻辑

后续分析时，不应该简单认为：

```text
点击 = 喜欢
```

而是组合多个被动信号。

---

## 弱负反馈

```text
已经 impression
但没有 open
```

解释：

```text
用户看见了，但选择跳过
```

只能作为弱负反馈。

---

## 弱正反馈

```text
article_open
```

说明标题或主题至少产生了兴趣。

但不能单独判断用户喜欢。

---

## 负反馈

例如：

```text
article_open
reading_time_sec = 4
max_scroll_percent = 8
```

说明：

```text
点进去了
但迅速退出
```

这种情况不应该因为“点击”被判断成强兴趣。

---

## 强正反馈

例如：

```text
reading_time_sec 较长
max_scroll_percent >= 70
```

说明用户进行了真实阅读。

---

## 很强正反馈

例如：

```text
original_link_click
article_reopen
```

可以给予更高权重。

---

# 17. 一个典型分析例子

假设 30 天数据：

```text
Agent

impression            100
open                   65
平均阅读时间           240 秒
平均 max_scroll         84%
original_link_click     28
```

而：

```text
AI 融资

impression            100
open                   18
平均阅读时间            21 秒
平均 max_scroll         24%
original_link_click      1
```

可以推断：

```text
Agent
→ 强兴趣

AI 融资
→ 低兴趣
```

不需要用户做任何评分。

---

# 18. Topic 偏好比 Source 偏好更重要

不要只建立：

```text
OpenAI = 喜欢
Anthropic = 喜欢
```

更应该分析：

```text
OpenAI
├── Agent / API / SDK
├── Coding
├── Model Release
├── Business
├── Funding
└── Interview
```

因为用户可能：

```text
喜欢 OpenAI Agent API
但完全不关心 OpenAI 融资新闻
```

因此文章的：

```text
topics
```

必须保持稳定并尽量标准化。

---

# 19. Topic 建议

第一版可以使用类似：

```text
agent
agent_framework
developer_tools
coding
api
sdk
model_release
model_capability
multimodal
reasoning
open_source
research
infrastructure
cloud
product
business
funding
policy
security
robotics
```

后续可以扩展。

避免同一概念出现多个不同名称：

```text
agent
agents
ai_agent
ai-agents
```

应该统一成：

```text
agent
```

---

# 20. 埋点统一封装

禁止业务代码到处直接写：

```dart
FirebaseAnalytics.instance.logEvent(...)
```

建议统一封装：

```dart
class AnalyticsService {
  AnalyticsService._();

  static final FirebaseAnalytics _analytics =
      FirebaseAnalytics.instance;

  static Future<void> articleImpression({
    required String articleId,
    required int position,
    required String feedDate,
  }) {
    return _analytics.logEvent(
      name: 'article_impression',
      parameters: {
        'article_id': articleId,
        'position': position,
        'feed_date': feedDate,
      },
    );
  }

  static Future<void> articleOpen({
    required String articleId,
    required int position,
    required String feedDate,
  }) {
    return _analytics.logEvent(
      name: 'article_open',
      parameters: {
        'article_id': articleId,
        'position': position,
        'feed_date': feedDate,
      },
    );
  }

  static Future<void> articleRead({
    required String articleId,
    required int readingTimeSec,
    required int maxScrollPercent,
  }) {
    return _analytics.logEvent(
      name: 'article_read',
      parameters: {
        'article_id': articleId,
        'reading_time_sec': readingTimeSec,
        'max_scroll_percent': maxScrollPercent,
      },
    );
  }

  static Future<void> originalLinkClick({
    required String articleId,
  }) {
    return _analytics.logEvent(
      name: 'original_link_click',
      parameters: {
        'article_id': articleId,
      },
    );
  }

  static Future<void> articleReopen({
    required String articleId,
  }) {
    return _analytics.logEvent(
      name: 'article_reopen',
      parameters: {
        'article_id': articleId,
      },
    );
  }
}
```

业务层只调用：

```dart
AnalyticsService.articleOpen(...)
```

便于以后：

```text
修改事件名称
增加统一参数
切换 Analytics Provider
接入 BigQuery
增加 Debug Log
```

---

# 21. 数据质量要求

## 不重复

同一个行为不要因为 Widget rebuild 重复发送。

错误：

```text
build()
→ logEvent()
```

Flutter Widget 可能多次 rebuild。

不要直接在 `build()` 中发送事件。

---

## 不发送文章正文

Firebase Event 中不要发送：

```text
完整正文
完整摘要
完整 URL
```

Event 只需要发送：

```text
article_id
```

文章详细 Metadata 应通过 `article_id` 与新闻数据表关联。

这样数据更干净，也更容易维护。

---

## 不使用 title 作为主键

标题可能：

```text
修改
翻译
截断
重复
```

因此所有事件必须以：

```text
article_id
```

为关联主键。

---

# 22. 隐私要求

不得将以下个人敏感信息作为 Analytics Event Parameter：

```text
姓名
邮箱
电话
密码
精确地址
身份证件信息
其他直接身份信息
```

本项目偏好学习只需要匿名行为数据。

不要求用户登录。

---

# 23. 后续自动学习数据流

第一阶段：

```text
Flutter
↓
Firebase Analytics
↓
人工 / 定期分析
```

后续可以升级：

```text
Flutter
↓
Firebase Analytics
↓
BigQuery Export
↓
每日聚合
↓
preference.json
↓
新闻筛选 / 排序任务
```

例如最终生成：

```json
{
  "topics": {
    "agent": 0.91,
    "developer_tools": 0.87,
    "model_release": 0.74,
    "funding": 0.19
  },
  "sources": {
    "OpenAI": 0.86,
    "Anthropic": 0.78
  }
}
```

该偏好模型只由用户的自然阅读行为产生。

---

# 24. MVP 验收标准

完成以下内容即可认为第一版埋点完成：

```text
[ ] 每篇文章有稳定 article_id
[ ] 每篇文章有 source
[ ] 每篇文章有 topics
[ ] article_impression 正常发送
[ ] article_open 正常发送
[ ] article_read 正常发送
[ ] reading_time_sec 排除后台时间
[ ] max_scroll_percent 正确
[ ] original_link_click 正常发送
[ ] article_reopen 可以识别
[ ] Widget rebuild 不会重复埋点
[ ] 不存在评分 / 点赞 / 点踩等额外交互
[ ] Firebase Realtime / DebugView 可以看到事件
```

---

# 25. 最终原则

整个推荐学习系统遵循：

```text
用户正常阅读
↓
后台无感采集行为
↓
分析真实兴趣
↓
优化下一批新闻
```

而不是：

```text
新闻
↓
要求用户评分
↓
要求用户反馈
↓
才能知道用户喜欢什么
```

**产品不向用户索取额外劳动，偏好学习是系统自己的责任。**
