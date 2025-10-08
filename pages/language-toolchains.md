---
title: Language Toolchains
outline: [1, 4]
---

# {{ $frontmatter.title }}

<script setup>
import { data } from '../.vitepress/chezmoi.data.js'
</script>

Currently I use [Mise](https://mise.jdx.dev/) to handle installation of various programming languages and their toolchains.

At the time of writing, these are the various languages and their versions that I have installed, for each environment that I use my dotfiles in.

<sup>Red: Language not installed for given environment</sup>
<br />
<sup>Yellow: Language differs between environments</sup>

<table>
  <thead>
    <tr>
      <th>Language</th>
      <th>Version (home)</th>
      <th>Version (work)</th>
    </tr>
  </thead>
  <tbody>
    <template v-for="(version, name) in data.languages">
      <tr>
        <td>{{ name }}</td>
        <template v-if="typeof version !== 'object'">
          <td><code>{{ version }}</code></td>
          <td><code>{{ version }}</code></td>
        </template>
        <template v-if="typeof version === 'object'">
          <td v-bind:style="[ version.home === null ? {'background-color': 'var(--vp-code-line-diff-remove-color)'} : version.work !== null && version.home !== version.work ? {'background-color': 'var(--vp-code-line-warning-color)'} : {}]"><code>{{ version.home === null ? 'N/A' : version.home }}</code></td>
          <td v-bind:style="[ version.work === null ? {'background-color': 'var(--vp-code-line-diff-remove-color)'} : version.home !== null && version.home !== version.work ? {'background-color': 'var(--vp-code-line-warning-color)'} : {}]"><code>{{ version.work === null ? 'N/A' : version.work }}</code></td>
        </template>
      </tr>
    </template>
  </tbody>
</table>