Feature: Using files as input and output
  In order to convert it to json
  Using a file as an input
  Using a file as an output

  Scenario Outline: Convert KAF to JSON
    Given the fixture file "<input_file>"
    And I put them through the kernel
    Then the output should match the fixture "<output_file>"
  Examples:
   | input_file            | output_file            |
   | kaf.1.xml             | kaf.1.json             |
   | kaf.2.xml             | kaf.2.json             |