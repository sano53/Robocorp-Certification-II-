from RPA.Robocorp.Vault import Vault     #Importing Vault package from Robocorp
secret = Vault().get_secret("credentials")       #Getting datata from credentials
USER_NAME = secret["username"]                  # Get username here
PASSWORD = secret["password"]                   # Get Password here
