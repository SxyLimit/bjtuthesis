= 相关技术

== 插入说明

我们可以用 `#figure` 来插入现有的不同格式的图片，如图 @fig-ai-agent。论文中尽量使用矢量图，如 `.pdf` 格式的图片。

#figure(label: <fig-ai-agent>, caption: [AI agent的组成.pdf])[
  #image("figures/AI agent的组成.pdf", width: 40%)
]

如表 @tab-compare 所示，这是一张自动调节列宽的表格。推荐两个常用的在线表格生成工具：Advanced Table Editor（<https://www.latex-tables.com/>）和 Tables Generator（<https://www.tablesgenerator.com/>）。

#figure(label: <tab-compare>, caption: [代码智能体相比 Text/JSON 在 LLM 动作上的优势])[
  #table(columns: 3)[
    & *代码智能体用于 LLM 动作* & *JSON 或 Text 用于 LLM 动作* \\
    预训练数据兼容性 & 有大量代码可用于预训练 & 需要针对特定格式进行数据整理 \\
    复杂操作支持 & 通过控制流和数据流原生支持 & 即便可行，也需要精心设计（例如定义新工具以模拟 if 语句） \\
    工具可用性 & 可以直接使用现有的软件包 & 需手动适配工具 \\
    自动反馈能力 & 反馈机制（如 traceback）作为基础机制已经在大多数编程语言中实现 & 需额外设计反馈流程 \\
  ]
]

如式 @eq-sample，给出了一个公式示例。

#math(display: "block")[
  \mathrm{Logits}(t_n) = \mathrm{GenModel}\bigl(t_n \mid \{\mathrm{input}, t_1, \ldots, t_{n-1}\}\bigr)
] <eq-sample>

如算法 @alg-sample，展示了一个伪代码算法。

#figure(label: <alg-sample>, caption: [CodeAgent-based Workflow])[
  #table(columns: 1)[
    *memory* ← [user_defined_task] \\
    while llm_should_continue(memory) \{ \\
    \quad action ← llm_get_next_action(memory) \\
    \quad observations ← execute_action(action) \\
    \quad memory ← memory + [action, observations] \\
    end while \\
  ]
]

这是一个无序列表：

- aaa
- bbb
- ccc

这是一个有序列表（默认编号格式）：

+ aaa
+ bbb
+ ccc

下面是两个有序列表（自定义编号格式），你可以按照你的偏好设置：

+[#n]* aaa
+[#n]* bbb
+[#n]* ccc

---

+[#a]* athesiaa
+[#a]* bbb
+[#a]* ccc

== 文献引用

文献引用可以使用两种方式，下面两种方式任选一个即可，但是需要全文统一。

引用文献方式一：文献 @Chase_LangChain_2022、文献 @wang2024executable。

引用文献方式二：文献 @Elovic_gpt-researcher_2023、文献 @smolagents。

== 关于代码

目前学院没有明确给出代码格式，你可以自己定义，也可以参照下面的示例。

```java
private void parseJSONWithJSONObject(String jsonData,SQLiteDatabase db){
    try {
        JSONObject jsonObject = new JSONObject(jsonData);
        JSONArray results;
        if(jsonObject.has("result")) results = jsonObject.getJSONArray("result");
        else return;;
        for (int i = 0; i < results.length(); i++) {
            JSONObject item = results.getJSONObject(i);
            String name = item.optString("name");
            String img = item.optString("img");
            String heat = item.optString("heat");
            String pinyin = getFullPinyin(name);
            if(name.length()>10||name=="null") continue;
            int calor=extractCalories(heat);
            try {
                String sql = "INSERT INTO food (foodname, img, calories, unit, pinyin) VALUES ('" + name + "', '" + img + "', "
+ calor + ", '100', '" + pinyin + "')";
                db.execSQL(sql);
                Log.d("We", "Insert successful: foodname " + name + ", img " + img + ", heat " + calor +  ", pinyin " + pinyin);
            } catch (SQLException e) {
                Log.e("We", "Insert failed: " + e.getMessage());
            }
        }
    }
    catch(Exception e){
        Log.d("Fooddatabase failed","failed",e);
        e.printStackTrace();
    }
}
```

```python
def generate_with_cue_words(self, background: str):
    problem, message_input = self.api_helper.generate_problem_with_cue_words(
```
