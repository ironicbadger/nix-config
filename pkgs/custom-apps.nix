{ lib, stdenv, undmg, ... }:

let
  # Define the location of your shared drive
  sharedDrivePath = "/Volumes/Storage";
  
  # Helper function to create a package from a .app directory
  mkAppFromDir = { name, version, src, description ? "", homepage ? "" }:
    stdenv.mkDerivation {
      inherit name version src;
      
      phases = [ "installPhase" ];
      
      installPhase = ''
        mkdir -p $out/Applications
        cp -R "$src" $out/Applications/
      '';
      
      meta = with lib; {
        inherit description homepage;
        platforms = platforms.darwin;
      };
    };
    
  # Helper function to create a package from a .dmg file
  mkAppFromDmg = { name, version, src, description ? "", homepage ? "" }:
    stdenv.mkDerivation {
      inherit name version src;
      
      nativeBuildInputs = [ undmg ];
      
      phases = [ "unpackPhase" "installPhase" ];
      
      installPhase = ''
        mkdir -p $out/Applications
        cp -R "*.app" $out/Applications/
      '';
      
      meta = with lib; {
        inherit description homepage;
        platforms = platforms.darwin;
      };
    };

  # Helper function to create a package from a .pkg installer
  mkAppFromPkg = { name, version, src, description ? "", homepage ? "" }:
    stdenv.mkDerivation {
      inherit name version src;
      
      phases = [ "installPhase" ];
      
      installPhase = ''
        mkdir -p $out/bin
        
        # Create an installer script that will be run by the user
        cat > $out/bin/install-${name} << EOF
#!/bin/sh
sudo installer -pkg "${src}" -target /
echo "${name} has been installed successfully!"
EOF
        
        chmod +x $out/bin/install-${name}
        
        # Create a README file with installation instructions
        mkdir -p $out/share/doc/${name}
        cat > $out/share/doc/${name}/README.md << EOF
# ${name} ${version}

${description}

To install ${name}, run the following command:

\`\`\`
install-${name}
\`\`\`

This will install ${name} using the official installer package.
EOF
      '';
      
      meta = with lib; {
        inherit description homepage;
        platforms = platforms.darwin;
      };
    };

in {
  # Pro Tools installer
  pro-tools-installer = mkAppFromPkg {
    name = "pro-tools";
    version = "2024.5"; # Update with your version
    src = "${sharedDrivePath}/Installers/Pro Tools Installer.pkg";
    description = "Professional digital audio workstation";
    homepage = "https://www.avid.com/pro-tools";
  };
  
  # Add more custom applications as needed
  # example-app = mkAppFromDmg {
  #   name = "example-app";
  #   version = "1.0";
  #   src = "${sharedDrivePath}/Applications/Example.dmg";
  #   description = "Example application";
  #   homepage = "https://example.com";
  # };
}
