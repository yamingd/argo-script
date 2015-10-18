package main

const Template = `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>API Wiki</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/3.0.1/normalize.min.css">
  <link rel="stylesheet" href="/public/gfm.css">
  <style>
    .container {
      margin: 2rem auto 4rem;
      max-width: 666px;
      padding: 13px;
    }
  </style>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.4/styles/github.min.css">
  <script src="https://cdnjs.cloudflare.com/ajax/libs/highlight.js/8.4/highlight.min.js"></script>
  <script>hljs.initHighlightingOnLoad();</script>
</head>
<body>
<main class="container markdown-body">
    {{ .Body }}
</main>
</body>
</html>`
