module.default = {
    settings: {
        "boundaries/root-path": __dirname,
    },
    rules: {
        "no-unused-vars": "error",
        "no-undef": "error",
        "no-console": 0,
        "import/extensions": 0,
        "no-underscore-dangle": [2, { "allow": ["__filename", "__dirname"] }]
    }
};
