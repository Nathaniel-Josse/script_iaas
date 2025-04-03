# 📌 Comment l’utiliser ?
1️⃣ Copier le script dans un fichier :

```bash
nano setup.sh
```
2️⃣ Coller le script, puis enregistrer avec CTRL+X → Y → Entrée<br>
3️⃣ Rendre le script exécutable :

```bash
chmod +x setup.sh
```
4️⃣ Lancer le script :

```bash
sudo ./setup.sh
```
🎯 Résultat attendu<br>
✅ Un serveur avec Nginx, PHP, et MySQL installé<br>
✅ Une application web de test disponible sur http://votre-serveur/<br>
✅ Un accès à MySQL avec un utilisateur et une base de données configurés

(Pour effacer ce qui a été déployé, il suffit de lancer les mêmes commandes sur le fichier undeploy.sh)
```bash
chmod +x undeploy.sh
```
```bash
sudo ./undeploy.sh
```