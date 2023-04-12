#!/bin/bash
TEST_CLASS="lt.markmerkk.TestClass"
TEST_METHOD="requiredTest1"
./gradlew :echopro:connectedDevDebugAndroidTest -Pandroid.testInstrumentationRunnerArguments.class="${TEST_CLASS}#${TEST_METHOD}"
