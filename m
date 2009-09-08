From: Eric Sandeen <sandeen-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Creating NILFS2 on Fedora 11
Date: Tue, 08 Sep 2009 11:15:39 -0500
Message-ID: <4AA6832B.7070905@redhat.com>
References: <2324ff2b0909062047scb58709h3255655c068661be@mail.gmail.com>
	<debc30fc0909062113h29610480wb4ea49c59eecdb39@mail.gmail.com>
Reply-To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
In-Reply-To: <debc30fc0909062113h29610480wb4ea49c59eecdb39-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Id: <linux-nilfs.vger.kernel.org>
List-Unsubscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://www.nilfs.org/pipermail/users>
List-Post: <mailto:users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>
List-Help: <mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=help>
List-Subscribe: <https://www.nilfs.org/mailman/listinfo/users>,
	<mailto:users-request-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org?subject=subscribe>
Sender: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
Errors-To: users-bounces-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org
To: NILFS Users mailing list <users-JrjvKiOkagjYtjvyW6yDsg@public.gmane.org>

J=E9r=F4me Poulin wrote:
> fdisk shows the partition type which should be 83 (Linux), not what FS
> it contains, most likely no utilities (like blkid) support detecting
> NilFS2 yet. Be sure to keep in mind the experimental nature of NilFS2
> before putting all your data on it.

That's right, blkid in fedora (also blkid upstream) does not yet
recognize nilfs; the devels said that the format is still too much in
flux to code the recognition into tools like this yet.

-Eric
