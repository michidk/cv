FROM qmcgaw/latexdevcontainer:latest
# FROM qmcgaw/latexdevcontainer:latest-full

# Install dependescies
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    # Tools
    curl wget \
    # Python
    python3 python3-pip

# Install just
RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /bin
