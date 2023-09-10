# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Authbot.Repo.insert!(%Authbot.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

Authbot.Repo.insert!(%Authbot.Static.GoonPrimaryGroup{
  primary_group: 134,
  name: "Tactical Narcotics Team",
  ticker: "[TNT]"
})

Authbot.Repo.insert!(%Authbot.Static.GoonPrimaryGroup{
  primary_group: 143,
  name: "Get Off My Lawn",
  ticker: "[LAWN]"
})

Authbot.Repo.insert!(%Authbot.Static.GoonPrimaryGroup{
  primary_group: 1008,
  name: "Dracarys.",
  ticker: "[D.C]"
})

Authbot.Repo.insert!(%Authbot.Static.GoonPrimaryGroup{
  primary_group: 1168,
  name: "Invidia Gloriae Comes",
  ticker: "[IGC]"
})

Authbot.Repo.insert!(%Authbot.Static.GoonPrimaryGroup{
  primary_group: 1329,
  name: "Stribog Clade",
  ticker: "[TRIAL]"
})

Authbot.Repo.insert!(%Authbot.Static.GoonPrimaryGroup{
  primary_group: 1353,
  name: "Sigma Grindset",
  ticker: "[5IGMA]"
})

Authbot.Repo.insert!(%Authbot.Static.GoonPrimaryGroup{
  primary_group: 1335,
  name: "Shadow Ultimatum",
  ticker: "[SHADO]"
})

