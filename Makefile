BUILD_VERSION := $(shell grep 'version:' pubspec.yaml | awk '{print $$2}')

clean: ## Cleans the environment
	@echo "╠ Cleaning the project..."
	@rm -rf pubspec.lock
	@fvm flutter clean

get:
	@echo "╠ Get packages"
	@rm -rf pubspec.lock
	@fvm flutter pub get

ios-install:
	@echo "╠ IOS => Pod installing.."
	@cd ios && rm -rf Podfile.lock && pod install
ios-update:
	@echo "╠ IOS => Pod repo updating.."
	@pod repo update
	@make ios-install

env:
	@echo "╠ SETTING ENV"
	@sh scripts/set_env.sh

gen: ## Build the files for changes
	@echo "╠ Building the project..."
	@flutter pub run build_runner build --delete-conflicting-outputs