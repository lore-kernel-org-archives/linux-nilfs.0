From: "Peter Smith" <smithpdo-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Mount memory allocation error
Date: Thu, 3 Jul 2008 12:19:53 +0200
Message-ID: <474dca090807030319w7ff440b0w1315c60fb7d56756@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1008934408=="
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Mime-version: 1.0
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

--===============1008934408==
Content-Type: multipart/alternative; 
	boundary="----=_Part_8736_14781085.1215080393458"

------=_Part_8736_14781085.1215080393458
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,
I recently upgraded my memory from 2G to 4G and this made it necessary to
change my kernel
from
2.6.22.5-31-default
to
2.6.22.5-31-bigsmp

Now I cannot mount nilfs2 partitions.
I get the error message:  mount.nilf2: ... ... Cannot allocate memory

My environment is
OpenSuse 10.3
nilfs 2.02
nilfs-utils 2.04

Yes, I did recompile/install nilfs and nilfs-utils while using the bigsmp
kernel.
When I switch back to the default kernel mount.nilfs2 works normally,
as does everything else.(but of course I don't have access to the full 4G
memory)

Your help would be greatly appreciated
Peter


-- 
This is Linux land. On quiet nights you can hear the Windows machines
rebooting.

------=_Part_8736_14781085.1215080393458
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,<br>I recently upgraded my memory from 2G to 4G and this made it necessary to change my kernel<br>from<br>2.6.22.5-31-default<br>to<br>2.6.22.5-31-bigsmp<br><br>Now I cannot mount nilfs2 partitions.<br>I get the error message:&nbsp; mount.nilf2: ... ... Cannot allocate memory<br>
<br>My environment is<br>OpenSuse 10.3<br>nilfs 2.02<br>nilfs-utils 2.04<br><br>Yes, I did recompile/install nilfs and nilfs-utils while using the bigsmp kernel.<br>When I switch back to the default kernel mount.nilfs2 works normally,<br>
as does everything else.(but of course I don&#39;t have access to the full 4G memory)<br><br>Your help would be greatly appreciated<br>Peter<br><br clear="all"><br>-- <br>This is Linux land. On quiet nights you can hear the Windows machines rebooting.

------=_Part_8736_14781085.1215080393458--

--===============1008934408==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
users mailing list
users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
https://www.nilfs.org/mailman/listinfo/users

--===============1008934408==--
