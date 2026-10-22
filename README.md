# Vue 双向绑定学习 Demo

一套可直接双击打开的教学示例，覆盖「会用 → 懂原理 → 能手写一个」。

## 文件说明

| 文件 | 内容 | 依赖网络 |
| --- | --- | --- |
| `index.html` | `v-model` 全场景交互教程：各种表单控件、修饰符、组件双向绑定、computed/watch | 需要（加载 Vue 3 CDN） |
| `principle.html` | 手写响应式系统：Vue 2 的 `Object.defineProperty` 版（含迷你模板编译器）+ Vue 3 的 `Proxy` 版 | 不需要，纯原生 JS |

用浏览器直接打开 `index.html` 即可，左边是源码、右边是可操作的实时效果。

## 核心知识点

### 1. v-model 本质是语法糖

```html
<input v-model="msg">
<!-- 完全等价于 -->
<input :value="msg" @input="msg = $event.target.value">
```

- **向下**：数据 → `:value` → 输入框显示
- **向上**：用户输入 → `@input` → 数据被赋值

### 2. 各控件的绑定规则

| 控件 | 绑定到的类型 | 关键点 |
| --- | --- | --- |
| `input[type=text]` / `textarea` | 字符串 | 必须有 `value`（或靠用户输入） |
| 单个 `checkbox` | 布尔 | 选中 `true`，未选 `false` |
| 多个 `checkbox` | 数组 | **必须写 `value`**，收集 value 进数组 |
| `radio` | 字符串 | 收集选中的那个 `value` |
| `select` 单选 | 字符串 | 建议首项写 `<option disabled value="">` |
| `select` 多选 | 数组 | 加了 `multiple` 就是数组 |

### 3. 修饰符

- `.lazy`：`input` 事件 → `change` 事件（失焦才同步）
- `.number`：`parseFloat` 能转就转数字，转不了保留原字符串
- `.trim`：去掉首尾空格

### 4. 组件上的双向绑定

Vue 3 的默认约定是 `modelValue` + `update:modelValue`：

```html
<!-- 子组件内部 -->
<input :value="modelValue" @input="$emit('update:modelValue', $event.target.value)">

<!-- 父组件 -->
<MyInput v-model="keyword" />
<!-- 等价于 -->
<MyInput :model-value="keyword" @update:model-value="keyword = $event" />

<!-- 多个 -->
<SizeSetter v-model:w="w" v-model:h="h" />
```

- Vue 3.4+ 可以直接用 `const model = defineModel()` 一行搞定
- Vue 2 时代用的是 `.sync` 修饰符（同一思路，不同语法）
- **单向数据流铁律**：子组件不能改 props，只能 `emit` 通知父组件改

### 5. 为什么数据变了视图会自动更新？

```
数据劫持（getter/setter 或 Proxy）
        ↓
渲染时读数据 → 触发 getter → 收集依赖（记住"谁用了我"）
        ↓
修改数据   → 触发 setter → 派发更新（通知用过的那些地方重算）
        ↓
重新生成 DOM → 视图更新
```

Vue 2 与 Vue 3 的区别只在于**怎么劫持**：

- **Vue 2 `Object.defineProperty`**：逐个 key 遍历劫持。感知不到新增/删除属性、数组下标赋值，所以要 `Vue.set` / 重写数组方法。
- **Vue 3 `Proxy`**：代理整个对象。新增、删除、下标、length 全都能拦到，而且是懒代理（用到嵌套对象才创建子代理），代价是放弃 IE。

`principle.html` 里这两套实现都跑起来了，可以亲手点点「新增属性」按钮看差别。

## 学习顺序建议

1. 打开 `index.html`，从第 1 节一路试到第 5 节，先建立手感
2. 重点盯着第 1 节：确认 `:value + @input` 和 `v-model` 完全等价
3. 再打开 `principle.html`，看 Vue 2 版怎么把 Lion-inside 的 `{{ }}` 和 `v-model` 编译成真实 DOM 操作
4. 最后对比 Vue 3 版，理解为什么要换成 Proxy
