#!/bin/bash
## Sample for regular concrete class to run
TEST_CLASS="lt.markmerkk.TestClass"
TEST_METHOD="requiredTest1"
./gradlew :echopro:connectedDevDebugAndroidTest -Pandroid.testInstrumentationRunnerArguments.class="${TEST_CLASS}#${TEST_METHOD}"

## Sample of running a test without uninstalling the app (for debugging)
./gradlew :echopro:connectedPosDebugAndroidTest -Pandroid.testInstrumentationRunnerArguments.class="com.harbortouch.echopro.ui.tests.order.menuAvailability.MenuAvailabilityPaginationTest#whenSwitchingDepartmentsThenNextPageIsEnabledOnlyForDepartmentWithALotOfItems" -x uninstallAll -x uninstallDebug -x installDebug


