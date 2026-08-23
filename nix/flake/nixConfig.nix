{
  flake.nixConfig = {
    extra-substituters = [
      "https://colmena.cachix.org"
    ];

    extra-trusted-public-keys = [
      "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
    ];
  };
}
