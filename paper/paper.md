---
title: 'ConSciR: An R package for Conservation Science data'
tags:
  - R
  - conservation science
  - cultural heritage
  - sustainability
  - humidity
authors:
  - name: Bhavesh Shah
    orcid: 0000-0001-8673-0589
    equal-contrib: true
    affiliation: 1
  - name: Annelies Cosaert
    orcid: 0009-0004-1269-4465
    equal-contrib: true
    affiliation: 2
  - name: Vincent Beltran
    corresponding: true
    equal-contrib: true
    affiliation: 3
affiliations:
  - name: English Heritage, Rangers House, London, UK
    index: 1
  - name: Royal Institute for Cultural Heritage, KIK-IRPA, Brussels, Belgium
    index: 2
  - name: Getty Conservation Institute, Los Angeles, CA, USA
    index: 3
citation_author: Shah et. al.
date: 20 August 2025
year: 2025
bibliography: paper.bib
output: rticles::joss_article
csl: apa.csl
journal: JOSS
---




# Summary

`ConSciR` is an R package [@RCoreTeam_2024] designed for cultural heritage conservation, providing tools for preventive conservation data analysis [@Cosaert_Beltran_2022]. `ConSciR` streamlines workflows across museums, galleries, and heritage sites by offering humidity calculations, conservation risk assessments, and sustainability metrics [@Cosaert_etal_2023]. The package contains a useful set of calculations for conservators, engineers, scientists, and data scientists to manage environmental data, assess collection risks, and develop custom analytical and communication tools in the R environment. In line with the FAIR principles [@larsson_2025], `ConSciR` is intended to evolve alongside emerging conservation science research and user feedback.

# Statement of need

Preventive conservation relies on managing environmental risks such as humidity, temperature, light, pests, and pollutants. Modern heritage management increasingly involves analysing large time-series environmental datasets to make sound data-driven decisions [@cosaert_2021]. Existing workflows typically require manual data tidying and knowledge of how to encode, often tedious, physical chemistry, mechanical, biology and thermodynamic calculations [@Cosaert_etal_2023]. Pre-compiled tools have been developed for these tasks, but these are either paid-for services, have been deprecated, provide only single data point calculations or are not open-source [@dpcalc_website_nd; @eClimateNotebook; @Padfield_2010; @Smulders_2014; @kupczak_2018; @pretzel_2023; @vaisala_website_nd]. There is a gap for an open-source package of commonly used calculations for conservation to create their own bespoke tools to adhere to preventive conservation standards [@Taylor_Beltran_2023]. This is highlighted in the 2022 Getty Conservation Institute’s Tools paper [@Cosaert_Beltran_2022], for the need for practical, user-friendly, cost-efficient, and decision-oriented tools for environmental monitoring. `ConSciR` is a step towards meeting conservation needs by consolidating environmental data cleaning, preservation metrics and calculations into a single R package. Interactive Shiny applications [@chang_2024] are included for quick data visualisation for users without prior training in coding.

# Features 

The functions in `ConSciR` are grouped into three themes: humidity calculations, conservation tools, and sustainability metrics. These address heritage needs for environmental analysis, risk assessment for material damage, and estimating the costs of mitigation, especially at a time when energy efficiency is important for heritage organisations. Humidity functions are used to determine the relationship between temperature and moisture in air, helping conservators, scientists, and engineers understand and manage damage to moisture-sensitive materials and air-conditioning systems. Humidity calculations for dew point, absolute humidity, humidity ratio, air density, and vapour pressure [@Buck_1981; @Wagner_2002] accept time-series datasets in formats commonly collected by heritage organisations (Date, Temperature and Humidity in columns). While some but not all of these calculations are currently available in R using the humidity [@humidity_R] and IAPWS95 [@IAPWS95] packages, calculating these variables typically requires knowledge of physical chemistry when using these packages. Humidity calculations have been checked for accuracy and stability against the IAPWS95 dataset [@IAPWS95], VAISALA online calculator [@vaisala_website_nd] and testthat framework [@testthat].

To facilitate workflow integration, tidying functions are also provided for formatting industry-standard sensor outputs. Psychrometric charts and graphical outputs are included for visualisation of the humidity functions. The conservation tools offer object damage calculations, for example, models for mould growth [@hukka_1999; @viitanen_2015; @zeng_2023] and lifetime estimates for organic materials [@michalski_2013]. Sustainability metrics are being added through consultation and as they are being developed through research.


``` r
library(ConSciR)
mydata |>
  graph_psychrometric(LowT = 10, HighT = 28, LowRH = 30, HighRH = 70, y_func = calcAH) 
```

![](paper_files/figure-latex/unnamed-chunk-2-1.pdf)<!-- --> 

# Usage

A small but growing group of coders in cultural heritage conservation includes environmental monitoring specialists, scientists, preventive conservators, and building engineers. These users benefit from the tools provided by `ConSciR`, which is designed for two key user groups: research data managers and domain-specific coders [@Cosaert_Shah_2025]. Research data managers, who typically have advanced coding experience, can use the package’s functions to build large-scale applications on complex datasets. Domain-specific coders have a toolset for answering conservation-related questions and automating routine data processing tasks. To support users, worked examples are available online as articles (https://bhavshah01.github.io/ConSciR). These examples provide conservation educators and trainers with resources to teach both coding and conservation theory [@beltran_2025].

The structure of `ConSciR` enables users to address a range of preventive conservation questions within a single, reproducible analytical framework, benefiting from the full array of tools available in R. The package’s functions support queries such as calculating dew point, comparing environmental risks between spaces, scenario analysis for changing HVAC setpoints, and evaluating climate change impacts [@shah_2025]. By integrating these functions, `ConSciR` helps data-driven decision-making and promotes best practice in collection care and preventive conservation.


# Acknowledgements

We acknowledge contributions from Emily R. Long, Marcin Zygmunt, Hebe Halstead and Avery Bazemore for the development of the `ConSciR` package.

# References
