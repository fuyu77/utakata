import pluginJs from "@eslint/js";
import globals from "globals";

export default [
  pluginJs.configs.recommended,
  {
    languageOptions: {
      globals: {
        ...globals.browser,
        ...globals.node
      }
    }
  },
  {
    files: ['**/*.js', '**/*.jsx'],
  },
  {
    ignores: ['app/assets/builds/**/*', 'vendor/**/*'],
  },
];
