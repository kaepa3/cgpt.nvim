# ChatCpt for nvim

this dependent "ChatGpt" Command

install "chatgpt" command

- https://github.com/mattn/chatgpt
- https://github.com/kaepa3/chatgpt

kaepa3 version can use godotenv.
differece is only that

# add plugin

```lua
require("lazy").setup({
    { "kaepa3/cgpt.nvim" },
})
```

# add comand

start current buffer code review

```bash
> CodeReview
```

ask ChatGpt

```bash
> Cgpt 'question'
```
