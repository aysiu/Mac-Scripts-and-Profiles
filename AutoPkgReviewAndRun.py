#!/usr/bin/python

import os
import subprocess

# Where is the recipe list (one recipe per line) located? Below is just an example. Modify as needed.
recipe_list='/Users/USERNAME/Library/Application Support/AutoPkgr/recipe_list.txt'

# Acceptable affirmative responses
affirmative_responses=["y", "yes", "sure", "definitely"]

def main():
    # Double-check the recipe list file exists
    if os.path.exists(recipe_list):
        # Update the repos
        subprocess.call(["autopkg","repo-update","all"])
        # Create an empty dictionary of recipes that need to be verified
        # Put the recipes into a list
        recipes = [recipe.rstrip('\n') for recipe in open(recipe_list)]
        # Loop through the recipes and see which ones need to be verified
        for recipe in recipes:
            print "Verifying trust info for %s" % recipe
            desired_result=recipe + ": OK"
            # See what the verified trust info looks like
            p = subprocess.Popen(["autopkg", "verify-trust-info", "-vv", recipe],stdout=subprocess.PIPE,stderr=subprocess.PIPE)
            verify_result,output_error = p.communicate()
            if desired_result in verify_result:
                print verify_result
            else:
                print output_error
                confirmation=raw_input("Do you trust these changes? (y/n) ")
                if confirmation.lower().strip() in affirmative_responses:
                    print "Updating trust info for %s" % recipe
                    subprocess.call(["autopkg", "update-trust-info", recipe])
                else:
                    print "Okay. Not updating trust for %s" % recipe
                    # Remove it from the list of recipes to run... no point in running it if the trust info isn't good
                    recipes.remove(recipe)
        # Whether there were things to verify or not, go ahead and run the recipes
        cmd = [ "autopkg", "run" ]
        cmd.extend(recipes)
        subprocess.call(cmd)

    else:
        print "%s does not exist. Aborting run." % recipe_list

if __name__ == "__main__":
    main()
