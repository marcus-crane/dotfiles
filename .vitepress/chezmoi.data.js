import fs from 'node:fs'

import { parse } from 'yaml'

export default {
  watch: ['../.chezmoidata/*.yaml'],
  load(watchedFiles) {
    let files = {}
    for (const file of watchedFiles) {
      files = Object.assign(files, parse(fs.readFileSync(file, 'utf-8')))
    }
    return files
  }
}