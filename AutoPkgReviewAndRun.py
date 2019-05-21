#!/usr/bin/python

import os
import subprocess

# Where is the recipe list (one recipe per line) located?
recipe_list='/Users/admin/Library/Application Support/AutoPkgr/recipe_list.txt'

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
            # See what the verified trust info looks like
            try:
                verify_result=subprocess.check_output(["autopkg", "verify-trust-info", "-vv", recipe], stderr=subprocess.STDOUT)
            except:
                verify_result="Verification failure"
            if verify_result=="Verification failure":
                print "Unable to verify %s" % recipe
            else:
                desired_result=recipe + ": OK"
                if desired_result not in verify_result:
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
