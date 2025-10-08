---
title: Tools
outline: [1, 4]
---

# {{ $frontmatter.title }}

<script setup>
import { data } from '../.vitepress/chezmoi.data.js'
</script>

Recently, I have been experimenting with using [Mise](https://mise.jdx.dev/) to handle tool installation as an alternative to stock operating system package managers.

At the time of writing, these are the tools I have installed as well as their versions.

<template v-for="(environments, backend) in data.tools">
<h2 :id="backend" tabindex="-1">{{ backend }}</h2>

These tools are installed using the <code>{{ backend }}</code> backend.

<template v-for="(tools, environment) in environments">
<h3 :id="backend + '-' + environment">{{ environment }}</h3>

<p v-if="environment === 'global'">
  These tools from <code>{{ backend }}</code> are installed on all machines that I deploy my dotfiles on.
</p>
<p v-else>
  These tools from <code>{{ backend }}</code> are only installed in my <code>{{ environment }}</code> environment.
</p>

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Version</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <template v-for="tool in tools">
      <tr>
        <td v-if="typeof(tool.url) !== 'undefined'">
          <a href="{{ tool.url }}">{{ tool.name !== undefined ? tool.name : tool.ref }}</a>
        </td>
        <td v-else>
          {{ tool.name !== undefined ? tool.name : tool.ref }}
        </td>
        <td v-if="typeof(tool.version) !== 'undefined'">
          <code>{{ tool.version }}</code>
        </td>
        <td v-else>
          <code>latest</code>
        </td>
        <td>{{ tool.description !== undefined ? tool.description : 'N/A' }}</td>
      </tr>
    </template>
  </tbody>
</table>

</template>
</template>