#!/Library/AutoPkg/Python3/Python.framework/Versions/3.7/bin/python3.7 

### This script updates AutoPkg repos, verifies trust info (with prompt to update after review), and runs recipes in a recipe list

import os
import subprocess

# Where is the recipe list (one recipe per line) located?
# Recipe list should be one recipe per line, separated by a carriage return ("\n")
recipe_list='/Users/a/Library/AutoPkg/recipe_list.txt'

# Acceptable affirmative responses
affirmative_responses=["y", "yes", "sure", "definitely"]

def main():
    # Double-check the recipe list file exists
    if os.path.exists(recipe_list):
        # Update the repos
        print("Updating recipe repos...")
        subprocess.call([ "/usr/local/bin/autopkg", "repo-update", "all" ])
        # Create an empty dictionary of recipes that need to be verified
        # Put the recipes into a list
        recipes = [recipe.rstrip('\n') for recipe in open(recipe_list)]
        # Loop through the recipes and see which ones need to be verified
        for recipe in recipes:
            print("Verifying trust info for {}".format(recipe))
            # See what the verified trust info looks like
            cmd = [ "/usr/local/bin/autopkg", "verify-trust-info", "-vv", recipe ]
            p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf8')
            out, err = p.communicate()
            if err:
                verify_result = "Verification failure"
            else:
                verify_result = out
            desired_result = recipe + ": OK"
            if desired_result not in verify_result:
                print(verify_result)
                confirmation = raw_input("Do you trust these changes? (y/n) ")
                if confirmation.lower().strip() in affirmative_responses:
                    print("Updating trust info for {}".format(recipe))
                    cmd = [ "/usr/local/bin/autopkg", "update-trust-info", recipe ]
                    p = subprocess.Popen(cmd, stdout=subprocess.PIPE, stderr=subprocess.PIPE, encoding='utf8')
                    out, err = p.communicate()
                    if err:
                        print("Unable to update trust info: {}".format(err))
                else:
                    print("Okay. Not updating trust for {}".format(recipe))
                    # Remove it from the list of recipes to run... no point in running it if the trust info isn't good
                    recipes.remove(recipe)
            else:
                print(verify_result)
        # Whether there were things to verify or not, go ahead and run the recipes
        print("Running recipes...")
        cmd = [ "/usr/local/bin/autopkg", "run" ]
        cmd.extend(recipes)
        subprocess.call(cmd)
    else:
        print("{} does not exist. Aborting run.".format(recipe_list))

if __name__ == "__main__":
    main()
