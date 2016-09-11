{
  network.description = "Sample";

  appserver = 
    { stdenv, config, pkgs, ...}:
      let 
        application = import ../default.nix {};
        gunicorn = pkgs.python3Packages.gunicorn;
        python = pkgs.python3Packages.python;
      in
      {
        environment.systemPackages = [
          pkgs.sysdig
        ];
        boot.extraModulePackages = [ pkgs.linuxPackages.sysdig ];
        services.openssh.enable = true;

        networking.firewall = {
          allowedTCPPorts = [ 8000 ];
        };

	systemd.services.sample = rec {
	  description = "Sample";

          wantedBy = [ "multi-user.target" ];


          environment = let
            penv = python.buildEnv.override {
              extraLibs = [ application ];
            };
          in {
            PYTHONPATH="${penv}/${python.sitePackages}/";
          };

	  # Start the service after the network is available
	  after = [ "network.target" ];
	  serviceConfig = {
	    # The actual command to run
	    ExecStart = ''${gunicorn}/bin/gunicorn sample.main:app \
              --workers 3 \
              --log-level=info \
              --bind=0.0.0.0:8000
            '';
            Restart = "on-failure";
            StartLimitInterval = 0;
	  };
          postStart = ''
            count=0
            until ${pkgs.curl.bin}/bin/curl -s -o /dev/null localhost:8000
            do
              if [ $count -gt 10 ]
              then
                echo "Service not started"
                exit 1
              fi
              count=$((count++))
              sleep 1
            done

            exit 0
          '';
	};

      };
}
