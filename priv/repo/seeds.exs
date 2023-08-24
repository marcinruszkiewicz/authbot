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

Authbot.Repo.insert!(%Authbot.Guilds.Config{
  guild_id: 1000108700175966318,
  verified_role_id: 1143865099258433548,
  gsf_role_id: 1143558717917364264,
  ally_role_id: 1143558859579990117
})

Authbot.Repo.insert!(%Authbot.Guilds.Config{
  guild_id: 1142854318920306688,
  verified_role_id: 1143952582931402886,
  gsf_role_id: 1142968668393853039,
  ally_role_id: 1142969348068225134
})
