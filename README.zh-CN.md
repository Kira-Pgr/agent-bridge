# agent-bridge

> 连接 AI 智能体，让 Claude Code 将任务委派给 GPT、Gemini 等模型。

**agent-bridge** 是一个 Claude Code 插件，用于桥接不同的 AI 智能体，让它们协同完成你的任务。当 Claude 遇到难以解决的 Bug、需要第二意见，或者你希望借助特定模型的能力时，无需离开当前工作流，直接将任务委派给其他 AI 智能体即可。

## 为什么需要它？

每个 AI 模型都有各自的优势。GPT 在某些推理任务上表现出色，Gemini 则带来不同的视角。与其在多个终端之间来回切换、复制粘贴上下文，不如让 Claude 直接将任务交给其他 AI CLI，然后将结果带回来。

```
你 → Claude Code → agent-bridge → Codex CLI (GPT) → 结果返回给 Claude
                                 → Gemini CLI      → 结果返回给 Claude
```

## 支持的智能体

| 智能体 | CLI 工具 | 可用模型 |
|--------|----------|----------|
| **codex** | [OpenAI Codex CLI](https://github.com/openai/codex) | gpt-5.4、gpt-5.3-codex、gpt-5.3-codex-spark |
| **gemini** | [Google Gemini CLI](https://github.com/google-gemini/gemini-cli) | gemini-2.5-pro、gemini-2.5-flash、gemini-3-pro、gemini-3-flash、gemini-3.1-pro-preview |

## 安装

### 通过 Claude Code 安装（推荐）

```
/install-plugin Kira-Pgr/agent-bridge
```

### 一键安装

```bash
curl -fsSL https://raw.githubusercontent.com/Kira-Pgr/agent-bridge/main/install.sh | bash
```

### 前提条件

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) v1.0.33+
- 至少安装一个智能体 CLI：
  - **Codex：** `npm install -g @openai/codex`，然后运行 `codex login` 进行认证
  - **Gemini：** `npm install -g @google/gemini-cli`，然后运行一次 `gemini` 进行认证

## 工作原理

1. 你让 Claude 将任务委派给 Codex 或 Gemini
2. Claude 通过交互式提示询问你要使用的模型和设置
3. 桥接子智能体启动并运行外部 CLI
4. 结果返回给 Claude，由 Claude 总结执行情况

该插件使用 **SessionStart 钩子**将指令注入 Claude 的上下文中，确保 Claude 在委派任务前先询问你的模型偏好。

## 使用方式

用自然语言告诉 Claude：

- *"用 Codex 跑一下这个，看看有没有不同的方案"*
- *"让 Gemini 审查一下这个函数"*
- *"把这个 Bug 交给 GPT 处理——我卡住了"*

或者直接指定智能体：

- `agent-bridge:codex` — 委派给 OpenAI Codex CLI
- `agent-bridge:gemini` — 委派给 Google Gemini CLI

## 项目结构

```
agent-bridge/
├── .claude-plugin/
│   ├── plugin.json              # 插件清单（含 SessionStart 钩子）
│   └── marketplace.json         # 市场元数据
├── agents/
│   ├── codex.md                 # Codex 桥接智能体
│   └── gemini.md                # Gemini 桥接智能体
├── scripts/
│   ├── session-context.sh       # 注入模型选择指令
│   └── check-deps.sh            # CLI 依赖检查
└── install.sh                   # 一键安装脚本
```

## 添加新智能体

想要桥接其他 AI CLI？步骤很简单：

1. 创建 `agents/<名称>.md`，编写智能体定义（参考现有智能体的格式）
2. 在 `plugin.json` 的 agents 数组中添加路径
3. 更新 `scripts/session-context.sh`，加入新智能体的模型选项
4. 提交 PR

## 许可证

MIT
