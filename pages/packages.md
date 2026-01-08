---
title: Packages
outline: [1, 4]
---

# {{ $frontmatter.title }}

<script setup>
import { data } from '../.vitepress/chezmoi.data.js'
</script>

The line between a package and a [tool](./tools.md) is quite blurry but for my use case, it's simply any tool installed from the standard[^standard] package manager of any given operating system.

These are the packages that I have installed at the time of writing.

## macOS

Most of my machines, both at home and at work are Macbooks

I used to run an iPhone for tighter integration but given I'm an Android user these days, I have a bit of an incentive towards cross-platform applications.

### Taps

These are third party repositories that ensure I can fetch the most up to date versions of a given package.

<table>
  <thead>
    <tr>
      <th>Name</th>
    </tr>
  </thead>
  <tbody>
    <template v-for="entry in data.packages.darwin.taps">
      <tr>
        <td v-if="typeof(entry.url) !== 'undefined'">
          <a :href="entry.url">{{ entry.name !== undefined ? entry.name : entry.ref }}</a>
        </td>
        <td v-else>
          {{ entry.name !== undefined ? entry.name : entry.ref }}
        </td>
      </tr>
    </template>
  </tbody>
</table>

### Brews

These are CLI tools installed from Homebrew

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <template v-for="entry in data.packages.darwin.brews">
      <tr>
        <td v-if="typeof(entry.url) !== 'undefined'">
          <a :href="entry.url">{{ entry.name !== undefined ? entry.name : entry.ref }}</a>
        </td>
        <td v-else>
          {{ entry.name !== undefined ? entry.name : entry.ref }}
        </td>
        <td>{{ entry.description !== undefined ? entry.description : 'N/A' }}</td>
      </tr>
    </template>
  </tbody>
</table>

### Casks

These are desktop apps installed from Homebrew

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <template v-for="entry in data.packages.darwin.casks">
      <tr>
        <td v-if="typeof(entry.url) !== 'undefined'">
          <a :href="entry.url">{{ entry.name !== undefined ? entry.name : entry.ref }}</a>
        </td>
        <td v-else>
          {{ entry.name !== undefined ? entry.name : entry.ref }}
        </td>
        <td>{{ entry.description !== undefined ? entry.description : 'N/A' }}</td>
      </tr>
    </template>
  </tbody>
</table>

### macOS App Store

These are macOS desktop apps installed from the App Store using [mas](#)

<table>
  <thead>
    <tr>
      <th>Name</th>
      <th>Description</th>
    </tr>
  </thead>
  <tbody>
    <template v-for="entry in data.packages.darwin.mas">
      <tr>
        <td>
          <a v-bind:href="'https://apps.apple.com/app/id' + entry.ref">
            {{ entry.name !== undefined ? entry.name : entry.ref }}
          </a>
        </td>
        <td>{{ entry.description !== undefined ? entry.description : 'N/A' }}</td>
      </tr>
    </template>
  </tbody>
</table>

## Linux

[^standard]: In the case of Homebrew, it's the defacto standard but not truly official

## Windows

While I have a Windows desktop, I don't use it for programming.

If I were forced to use it, I would just install the Linux packages using WSL2.

In fact, I have done that in the past but I would end up doing work instead of playing videogames hence adopting Windows as a deterrent to getting work done.