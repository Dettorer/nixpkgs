{ lib
, buildPythonPackage
, fetchFromGitHub
, osmnx
, pythonOlder
, pyyaml
, shapely
}:

let
  shapely1 = shapely.overridePythonAttrs (oldAttrs: rec {
    version = "1.8.5.post1";
    src = oldAttrs.src.override {
      pname = "Shapely";
      inherit version;
      hash = "sha256-7zvnBcPqwoKigFjmxuVQNBmyUPSCMg3yFyq8vqZCyDE=";
    };
  });
in
buildPythonPackage rec {
  pname = "prettymaps";
  version = "1.0.0";
  format = "setuptools";

  # disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "marceloprates";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-F8q1+rARDDc++KREfSVofcsVd2cv68FFAtBEvkFCEXQ=";
  };

  patches = [ ./0001-requirements-loosen-the-dependency-version-match.patch ];

  propagatedBuildInputs = [
    osmnx
    shapely
    pyyaml
  ];

  # Tests require network
  doCheck = false;

  pythonImportsCheck = [
    "prettymaps"
  ];

  meta = with lib; {
    description = "A Python package to draw maps with customizable styles from OpenStreetMap data.";
    homepage = "https://github.com/marceloprates/prettymaps";
    license = licenses.mit;  # XXX: will probably change for AGPLv3 on next release
    maintainers = with maintainers; [ dettorer ];
  };
}

