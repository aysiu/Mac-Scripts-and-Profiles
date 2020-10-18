#!/Library/AutoPkg/Python3/Python.framework/Versions/Current/bin/python3 

### This script updates AutoPkg repos, verifies trust info (with prompt to update after 
### review), and runs recipes in a recipe list

import argparse
import os
import subprocess
import sys

# Where is the recipe list (one recipe per line) located?
# Recipe list should be one recipe per line, separated by a carriage return ("\n")
recipe_list = os.path.expanduser('~/Library/AutoPkg/recipe_list.txt')

# Acceptable affirmative responses
affirmative_responses = ["y", "yes", "sure", "definitely"]

def get_options(recipe_list):
    parser = argparse.ArgumentParser(description="Verifies and runs recipes in \
        ~/Library/AutoPkg/recipe_list.txt")
    parser.add_argument('--verifyonly', help="Only verify the recipes. Do not run AutoPkg.",
        action="store_true")
    parser.add_argument('--runonly', help="Only run the recipe list. Do not verify trust \
        info.", action="store_true")
    parser.add_argument('--recipe-list', '-l', help="Path to recipe list file. If not specified, \
        the default location of ~/Library/AutoPkg/recipe_list.txt will be used instead")
    args = parser.parse_args()
    # If it's verify only and run only, give an error message
    if args.verifyonly and args.runonly:
        print("The verify only and run only options are mutually exclusive.")
        sys.exit(1)
    # If it's verify only, don't run
    elif args.verifyonly:
        recipeverify = True
        reciperun = False
    # If it's run only, don't verify
    elif args.runonly:
        recipeverify = False
        reciperun = True
    # If it's neither verify only or run only, do both
    else:
        recipeverify = True
        reciperun = True
    # See if there's a recipe list specified
    if args.recipe_list:
        recipelist = args.recipe_list
    else:
        recipelist = recipe_list
    return recipeverify, reciperun, recipelist

def get_recipe_list(recipe_list):
    # Double-check the recipe list file exists
    if os.path.isfile(recipe_list):
        # Put the recipes into a list
        try:
            recipes = [recipe.rstrip('\n') for recipe in open(recipe_list)]
        except:
            print("Unable to get recipe list {} into a list. Aborting run.".format(recipe_list))
            sys.exit(1)
        return recipes
    else:
        print("{} does not exist. Aborting run.".format(recipe_list))
        sys.exit(1)

def verify_recipes(recipes, affirmative_responses):
    # Update the repos
    print("Updating recipe repos...")
    subprocess.call([ "/usr/local/bin/autopkg", "repo-update", "all" ])
    # Loop through the recipes and see which ones need to be verified
    for recipe in recipes:
        print("Verifying trust info for {}".format(recipe))
        # See what the verified trust info looks like
        cmd = [ "/usr/local/bin/autopkg", "verify-trust-info", "-vv", recipe ]
        p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            encoding='utf8')
        out, err = p.communicate()
        if err:
            verify_result = "Verification failure"
        else:
            verify_result = out
        desired_result = recipe + ": OK"
        if desired_result not in verify_result:
            print(err)
            confirmation = input("Do you trust these changes? (y/n) ")
            if confirmation.lower().strip() in affirmative_responses:
                print("Updating trust info for {}".format(recipe))
                cmd = [ "/usr/local/bin/autopkg", "update-trust-info", recipe ]
                p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                    encoding='utf8')
                out, err = p.communicate()
                if err:
                    print("Unable to update trust info: {}".format(err))
            else:
                print("Okay. Not updating trust for {}".format(recipe))
                # Remove it from the list of recipes to run... no point in running it if
                # the trust info isn't good
                recipes.remove(recipe)
        else:
            print(verify_result)
    return recipes

def run_recipes(recipes):
        print("Running recipes...")
        cmd = [ "/usr/local/bin/autopkg", "run" ]
        cmd.extend(recipes)
        try:
            subprocess.call(cmd)
        except:
            print("Unable to run recipes. Aborting run.")
            sys.exit(1)

def main():
    # Get arguments
    recipeverify, reciperun, recipelist = get_options(recipe_list)

    # Get recipe list
    recipes = get_recipe_list(recipelist)

    if recipeverify:
        # Get verified recipes
        recipes = verify_recipes(recipes, affirmative_responses)

    if reciperun:
        # Run the recipes
        run_recipes(recipes)

if __name__ == "__main__":
    main()
