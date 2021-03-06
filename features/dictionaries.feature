@wip
Feature: Dictionaries Upload

    @auth
    Scenario: Upload a new dictionary and patch it
        When we upload a new dictionary with success
        """
        {"name": "test", "language_id": "en"}
        """
        Then we get new resource
        """
        {"name": "test", "language_id": "en", "type": "dictionary"}
        """

        When we upload to an existing dictionary with success
        """
        {"name": "test", "language_id": "en"}
        """
        Then we get existing resource
        """
        {"name": "test", "language_id": "en", "type": "dictionary"}
        """

    @auth
    Scenario: Update dictionary
        When we upload a new dictionary with success
        """
        {"name": "dict", "language_id": "en"}
        """

        And we patch latest
        """
        {"content": {"foo": 1, "bar": 0}}
        """

        Then we get updated response
        """
        {}
        """

        When we delete latest
        Then we get ok response

    @auth
    Scenario: Create duplicate dictionary for different languages
        When we upload a new dictionary with success
        """
        {"name": "dict", "language_id": "en"}
        """

        When we upload a new dictionary with success
        """
        {"name": "dict", "language_id": "ro"}
        """
      
        
     @auth
    Scenario: Create duplicate dictionary for the same language
        When we upload a new dictionary with success
        """
        {"name": "dict", "language_id": "en", "type": "dictionary"}
        """

        When we post to "/dictionaries"
        """
        {"name": "dict", "language_id": "en", "type": "dictionary"}
        """   
        Then we get error 400
        """
        {"_issues": {"name": "duplicate"}}
        """ 
        
    @auth
    Scenario: User dictionary
        When we post to "/users"
            """
            {"username": "foo", "email": "foo@bar.com", "is_active": true, "sign_off": "abc"}
            """
        And we post to "/dictionaries"
            """
            {"name": "#users._id#:en", "language_id": "en", "user": "#users._id#", "content": {"bar": 1}}
            """
        Then we get new resource
        """
        {}
        """

        When we patch "/dictionaries/#dictionaries._id#"
            """
            {"content": {"foo": 1}}
            """
        Then we get updated response
            """
            {}
            """

        When we get "/dictionaries/#dictionaries._id#"
        Then we get existing resource
            """
            {"content": {"foo": 1, "bar": 1}}
            """

     @auth
    Scenario: Create personal duplicate dictionary for different languages
        When we post to "/users"
            """
            {"username": "foo", "email": "foo@bar.com", "is_active": true, "sign_off": "abc"}
            """
        And we post to "/dictionaries"
            """
            {"name": "#users._id#:en", "language_id": "en", "user": "#users._id#"}
            """
        Then we get new resource

        When we post to "/dictionaries"
            """
            {"name": "#users._id#:en", "language_id": "ro", "user": "#users._id#"}
            """
        Then we get new resource
        When we patch "/dictionaries/#dictionaries._id#"
            """
            {"type": "abbreviations"}
            """
        Then we get error 400
            """
            {"_issues": {"validator exception": "400: The dictionary type cannot be changed."}}
            """


     @auth
    Scenario: Create personal duplicate abbreviations dictionary for different languages
        When we post to "/users"
            """
            {"username": "foo", "email": "foo@bar.com", "is_active": true, "sign_off": "abc"}
            """
        And we post to "/dictionaries"
            """
            {"name": "#users._id#:en", "language_id": "en", "user": "#users._id#", "type": "abbreviations"}
            """
        Then we get new resource

        When we post to "/dictionaries"
            """
            {"name": "#users._id#:en", "language_id": "ro", "user": "#users._id#", "type": "abbreviations"}
            """
        Then we get new resource
    
        
     @auth
    Scenario: Create personal duplicate dictionary for the same language
        When we post to "/users"
            """
            {"username": "foo", "email": "foo@bar.com", "is_active": true, "sign_off": "abc"}
            """
        And we post to "/dictionaries"
            """
            {"name": "#users._id#:en", "language_id": "en", "user": "#users._id#"}
            """
        Then we get new resource

        When we post to "/dictionaries"
            """
            {"name": "#users._id#:en", "language_id": "en", "user": "#users._id#"}
            """
        Then we get error 400
            """
            {"_issues": {"name": "duplicate"}}
            """

    @auth
    Scenario: Create personal duplicate abbreviations dictionary for the same language
        When we post to "/users"
            """
            {"username": "foo", "email": "foo@bar.com", "is_active": true, "sign_off": "abc"}
            """
        And we post to "/dictionaries"
            """
            {"name": "#users._id#:en", "language_id": "en", "user": "#users._id#", "type": "abbreviations"}
            """
        Then we get new resource

        When we post to "/dictionaries"
            """
            {"name": "#users._id#:en", "language_id": "en", "user": "#users._id#", "type": "abbreviations"}
            """
        Then we get error 400
            """
            {"_issues": {"name": "duplicate"}}
            """

    @auth
    Scenario: Create personal abbreviations dictionary without user fails
        When we post to "/users"
            """
            {"username": "foo", "email": "foo@bar.com", "is_active": true, "sign_off": "abc"}
            """
        And we post to "/dictionaries"
            """
            {"name": "#users._id#:en", "language_id": "en", "type": "abbreviations"}
            """
        Then we get error 400
            """
            {"_issues": {"user": "missing"}, "_message": "User is required for the abbreviations dictionary."}
            """