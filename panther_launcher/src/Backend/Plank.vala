using Plank;

namespace Panther
{
	public class TestClient : Object, Plank.UnityClient
	{
		public void remove_launcher_entry (string sender_name)
		{
			print ("Client '%s' was terminated\n", sender_name);
		}

		public void update_launcher_entry (string sender_name, GLib.Variant parameters, bool is_retry = false)
		{
			print ("Client '%s' requests an update\n", sender_name);

			// Decode and process the given "paramaters" argument
			string app_uri;
			VariantIter prop_iter;
			parameters.get ("(sa{sv})", out app_uri, out prop_iter);

			print ("=> '%s'\n   %s\n", app_uri, decode_payload (prop_iter));
		}

		static string decode_payload (VariantIter prop_iter)
		{
			var result = new StringBuilder ();

			string prop_key;
			Variant prop_value;

			while (prop_iter.next ("{sv}", out prop_key, out prop_value)) {
				if (prop_key == "count") {
					var val = prop_value.get_int64 ();
					result.append (("count = %" + int64.FORMAT + "; ").printf (val));
				} else if (prop_key == "count-visible") {
					var val = prop_value.get_boolean ();
					result.append ("count-visible = %s; ".printf (val ? "true" : "false"));
				} else if (prop_key == "progress") {
					var val = prop_value.get_double ();
					result.append ("progress = %f; ".printf (val));
				} else if (prop_key == "progress-visible") {
					var val = prop_value.get_boolean ();
					result.append ("progress-visible = %s; ".printf (val ? "true" : "false"));
				} else if (prop_key == "urgent") {
					var val = prop_value.get_boolean ();
					result.append ("urgent = %s; ".printf (val ? "true" : "false"));
#if HAVE_DBUSMENU
				} else if (prop_key == "quicklist") {
					/* The value is the object path of the dbusmenu */
					unowned string dbus_path = prop_value.get_string ();
					result.append ("quicklist = %s; ".printf (dbus_path));
#endif
				}
			}

			return (owned) result.str;
		}
	}
}
