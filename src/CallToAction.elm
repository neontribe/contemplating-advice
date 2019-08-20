module CallToAction exposing (callToActionButton, callToActionNav)

-- Potential to move all of this into Copy.Render

import Copy.Keys exposing (CallToActionRecord, CallToActionType(..))
import Html exposing (Html, a, div, span, text)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onClick)
import Icon exposing (getIcon)
import Messages exposing (Msg(..))


callToActionButton : CallToActionRecord -> String -> Html Msg
callToActionButton callToAction aClass =
    if callToActionNoDesktopButton callToAction.action then
        div []
            [ span []
                [ getIcon callToAction.icon (Just "button--icon")
                , span [] [ text callToAction.promptLong ]
                ]
            , span []
                [ text callToAction.displayHref ]
            ]

    else
        a
            [ class
                (if callToActionNoDesktopButton callToAction.action then
                    "mobile-only button button--full-width " ++ aClass

                 else
                    "button button--full-width " ++ aClass
                )
            , href
                (if callToActionNoDesktopButton callToAction.action then
                    "tel:" ++ callToAction.href

                 else
                    callToAction.href
                )
            , onClick (ButtonPress "call-to-action" callToAction.category "button" True)
            ]
            [ getIcon callToAction.icon (Just "button--icon")
            , span [] [ text callToAction.promptLong ]
            ]


callToActionNoDesktopButton : CallToActionType -> Bool
callToActionNoDesktopButton actionType =
    if actionType == Phone then
        True

    else
        False


callToActionNav : CallToActionRecord -> String -> Html Msg
callToActionNav cta context =
    case context of
        "nav" ->
            navItem cta.icon cta.href "call-to-action" cta.category cta.promptShort cta.promptLong cta.displayHref cta.action

        _ ->
            text ""


navItem : String -> String -> String -> String -> String -> String -> String -> CallToActionType -> Html Msg
navItem icon link category action shortLinkText longLinkText displayLink actionType =
    case actionType of
        Phone ->
            div [ class "nav-item" ]
                [ a [ href ("tel:" ++ link), onClick (ButtonPress category action (action ++ "-nav") True), class "mobile-only" ]
                    [ getIcon icon (Just "nav-item-text nav-icon")
                    , span [ class "nav-item-text" ]
                        [ span [ class "mobile-only" ] [ text shortLinkText ]
                        ]
                    ]
                , div [ class "nav-item--text-only desktop-only" ]
                    [ span [ class "nav-item-text" ] [ text longLinkText ]
                    , span [ class "nav-item-text" ] [ text displayLink ]
                    ]
                ]

        _ ->
            div [ class "nav-item" ]
                [ a [ href link, onClick (ButtonPress category action (action ++ "-nav") True) ]
                    [ getIcon icon (Just "nav-item-text nav-icon")
                    , span [ class "nav-item-text" ]
                        [ span [ class "mobile-only" ] [ text shortLinkText ]

                        -- Note: longLinkText not rendered for phone number in Haven instance
                        , span [ class "desktop-only" ] [ text longLinkText ]
                        ]
                    ]
                ]
