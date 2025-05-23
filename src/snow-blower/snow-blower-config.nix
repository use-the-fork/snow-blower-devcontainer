{config, ...}: {
  config = {
    modules.languages = {
      javascript = {
        enable = false;
      };
      php = {
        enable = true;
        settings = {
          extensions = ["grpc" "redis" "imagick" "memcached" "xdebug"];
          ini = ''
            memory_limit = 5G
            max_execution_time = 90
          '';
        };
      };
    };
  };
}
