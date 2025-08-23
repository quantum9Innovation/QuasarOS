<!-- markdownlint-disable MD013 -->

# QuasarOS

```txt
/*****                                                 /******   /****
|*    |  |*   |    **     ****     **    *****        |*    |  /*    *
|*    |  |*   |   /* *   /*       /* *   |*   |      |*    |  |*
|*    |  |*   |  /*   *   ****   /*   *  |*   /     |*    |   ******
|*  * |  |*   |  ******       |  ******  *****     |*    |         |
|*   *   |*   |  |*   |   *   |  |*   |  |*  *    |*    |   *     |
 **** *   ****   |*   |    ****  |*   |  |*   *   ******    *****
```

My highly experimental Nix (and \*nix) based OS

## Technical Overview

```mermaid
flowchart TB
    %% Styles
    classDef userConfig fill:#a8d1f0,stroke:#000
    classDef quasarOS fill:#d4b3e8,stroke:#000
    classDef nixos fill:#90EE90,stroke:#000
    classDef kernel fill:#d3d3d3,stroke:#000
    classDef external fill:#FFE4B5,stroke:#000
    classDef process fill:#F0F8FF,stroke:#000

    subgraph "User Configuration Layer"
        UC["User Config"]
        HC["Hardware Config"]
        RC["Remote Config"]
    end

    subgraph "QuasarOS Layer"
        FS["Flake System"]
        CSC["Core System Configuration"]
        HMC["Home Manager Config"]

        subgraph "Modules"
            WM["Window Manager (Hyprland)"]
            SB["Secure Boot (Lanzaboote)"]
            SBS["Status Bar Styling"]
            UF["Utility Functions"]
        end
    end

    subgraph "NixOS Layer"
        ND["Nix Derivations"]
        NPM["Nix Package Manager"]
        NM["NixOS Modules"]
    end

    subgraph "Linux Kernel Layer"
        LK["Linux Kernel"]
    end

    subgraph "External Sources"
        GR["Git Repositories"]
        NPR["Nix Package Registry"]
    end

    %% Relationships
    UC --> FS
    HC --> CSC
    RC --> FS

    FS --> CSC
    CSC --> HMC
    CSC --> WM
    CSC --> SB
    CSC --> SBS

    WM --> ND
    SB --> ND
    HMC --> ND

    ND --> NPM
    NPM --> NM
    NM --> LK

    GR -.-> FS
    NPR -.-> NPM

    %% Click Events
    click FS "https://github.com/quantum9innovation/quasaros/blob/main/flake.nix"
    click CSC "https://github.com/quantum9innovation/quasaros/blob/main/configuration.nix"
    click HMC "https://github.com/quantum9innovation/quasaros/blob/main/home.nix"
    click WM "https://github.com/quantum9innovation/quasaros/blob/main/modules/hyprland.nix"
    click SB "https://github.com/quantum9innovation/quasaros/blob/main/modules/lanzaboote.nix"
    click SBS "https://github.com/quantum9innovation/quasaros/blob/main/modules/waybar.css"
    click UF "https://github.com/quantum9innovation/quasaros/blob/main/utils.nix"

    %% Legend
    subgraph Legend
        L1["→ Direct Flow"]
        L2["--> Dependency"]
        L3["User Config"]:::userConfig
        L4["QuasarOS"]:::quasarOS
        L5["NixOS"]:::nixos
        L6["Kernel"]:::kernel
    end

    %% Apply styles
    class UC,HC,RC userConfig
    class FS,CSC,HMC,WM,SB,SBS,UF quasarOS
    class ND,NPM,NM nixos
    class LK kernel
    class GR,NPR external
```

Generated with [GitDiagram](https://gitdiagram.com/quantum9innovation/quasaros).

## Development

Most development happens on other branches (and there will likely be a lot of them at any given time). Take a look at some others for a sampling of the latest experiments. `main` can be considered (relatively) stable.

## About

As this repository is nowhere near a finished state, I would recommend subscribing to releases, so you can receive a GitHub notification when the first stable release is ready. You're probably wondering, however, what and perhaps *why* this is. Here's a little bit of context …

As part of my journey into the dangerous, mind-bending terrain of purely functional programming and hyper-abstract quasi-philosophical mathematical ideas (see e.g. [category theory](https://en.wikipedia.org/wiki/Category_theory) and [topos theory](https://en.wikipedia.org/wiki/Topos)), I discovered [NixOS](https://nixos.org/). What is NixOS?

Unlike traditional operating systems which rely on non-deterministic package management mechanisms compromised by a myriad of internal states, Nix takes a declarative approach to configuring the entire operating system. It is a Linux distribution that ships with its own package manager that installs packages in a deterministic way by building them in isolation using pure functions known as "derivations."

In NixOS, there is no state. The entire system is derived from a handful of configuration files, which build the system in its entirety. The same configuration can be deployed across multiple machines\[^1\] and you get identical systems.

As a Haskell addict, my brain was severely warped from the study of abstraction, and I began to examine some potential theories related to the abstraction of NixOS. You see, NixOS is really an abstraction on top of the Linux kernel. Unlike other distributions, which rely on internal state and therefore are not fully abstracted, NixOS specifies a language for building an operating system.

Taking this a bit further, we can abstract the Nix system configuration by creating a pure function ("derivation") that builds the standard configuration to build the system. Yes, we're talking about a derivation to build a derivation to build an operating system. At this point, if you have not been exposed to the pinnacle of abstraction that is category theory, you might want to stop reading.

This abstraction on top of NixOS allows for a custom Linux distribution to be built on top of NixOS. This distribution can ship with a series of default system configurations and packages, which can then be further customized by a user configuration, thereby further abstracting the already-abstracted NixOS configuration.

Of course, the choice of what those default system settings should be is highly personal. QuasarOS is a collection of my personal preferences that can be lightly tweaked through user configuration. This is possible because it exports not a system configuration but a morphism which transforms an object of type user configuration to an object of type system configuration\[^2\].

To reach the pinnacle of abstraction, you must complete one more step. Both QuasarOS and the user configuration must be deployed to remote version-controlled repositories, which can then be used as inputs to the Nix derivation that builds the system, allowing for your entire system to be configured from afar (via git). This leaves you with a dead-simple effective system configuration that lives on your local machine. This configuration merely pulls in the user configuration and feeds it into the QuasarOS system builder, also pulled over the network.

What this means in practice is that user-specific settings like the device hostname and other identifying details (user configuration) can be stored in a separate repository from the collection of default system settings (QuasarOS). Of course, this is a highly experimental and probably quixotic idea, which is precisely why I had to test it.

Oh, and did I mention that QuasarOS uses almost exclusively unstable packages? You're going to need to be ready to do a lot of generation backtracing if you want to daily drive this. Good luck!

\[^1\]: Assuming identical hardware; in reality, you need a special hardware configuration for each machine.

\[^2\]: It also allows for custom user configurations to be injected into the build process to take into account differences between e.g. hardware configuration across devices.
