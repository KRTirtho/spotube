/**
 * @type {import("eslint").Linter.Config}
 */
const config = {
    parser: "@typescript-eslint/parser",
    extends: [
        "plugin:react/recommended",
        "plugin:@typescript-eslint/recommended",
        "plugin:prettier/recommended",
    ],
    plugins: ["react", "@typescript-eslint"],
    env: {
        browser: true,
        es6: true,
    },
    settings: {
        react: {
            version: "16.14.0",
        },
    },
    globals: {
        Atomics: "readonly",
        SharedArrayBuffer: "readonly",
    },
    ignorePatterns: [".eslintrc.js", "./src/reportWebVitals.ts"],
    parserOptions: {
        ecmaFeatures: {
            jsx: true,
        },
        ecmaVersion: 2018,
        sourceType: "module",
        project: "./tsconfig.json",
        tsconfigRootDir: __dirname,
    },
    rules: {
        "@typescript-eslint/no-var-requires": "off",
        "prettier/prettier": "warn",
        "react/prop-types": "off",
        "linebreak-style": "off",
        "react/react-in-jsx-scope": "off",
        "@typescript-eslint/explicit-module-boundary-types": "off",
    },
};

module.exports = config;
