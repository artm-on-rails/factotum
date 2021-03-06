# Jacks of various trades

This is an example of user management with users in overlapping groups and
special users with special permissions with respect to the groups.

User model is [`Jack`][1], user group model is [`Trade`][2] and join model is
[`Occupation`][3]. User/group permissions are established by [`Ability`][5] model 
with [CanCanCan][4] gem (see [Defining Abilities][6] at CanCanCan wiki). 
Authorization is performed in [`JacksController`][11], [`TradesController`][12] 
and [`ProfilesController`][13]. Abilities are also used for hiding / disabling
parts of the views (implemented in [Jacks views][14], neglected in Trades views, 
Profiles views reuse partials from the Jack views) and for further strengthening
the [Strong Parameters][15] by making permitted params depend on current ability.

The permissions schema is tested with [integration tests][7], to make sure that 
all components are connected correctly.

One important caveat is the use of nested attributes for editing Jack's Trades or 
Trade's Jacks. CanCanCan doesn't authorize nested attributes out of the box, 
therefore a CanCanCan [extension][8] is provided that adds nested attributes 
authorization. The added functionality is monkey patched onto the gem so that 
the actual application code appears as a normal CanCanCan-based code. The 
extension is quite limited in its functionality and only implements the bare
minimum required for this example. 

Forms use [simple_form][9]'s form builder implementation and [cocoon][10] 
helpers for editing nested models.

[1]: app/models/jack.rb
[2]: app/models/trade.rb
[3]: app/models/occupation.rb
[4]: https://github.com/CanCanCommunity/cancancan
[5]: app/models/ability.rb
[6]: https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
[7]: test/integration
[8]: config/initializers/authorize_nested_attributes.rb
[9]: https://github.com/plataformatec/simple_form
[10]: https://github.com/nathanvda/cocoon
[11]: app/controllers/jacks_controller.rb
[12]: app/controllers/trades_controller.rb
[13]: app/controllers/profiles_controller.rb
[14]: app/views/jacks
[15]: https://edgeguides.rubyonrails.org/action_controller_overview.html#strong-parameters
