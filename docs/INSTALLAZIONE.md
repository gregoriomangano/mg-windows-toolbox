# Installazione per principianti

Questa guida spiega come installare M.G Windows Toolbox con il metodo automatico oppure con il download manuale del file ZIP.

## Metodo consigliato — Installazione automatica con PowerShell

Questo metodo scarica soltanto la release ufficiale `v0.3.0-beta.5`, verifica automaticamente il checksum SHA-256, installa il programma nella cartella personale di Windows e crea il collegamento nel menu Start. Se esiste una precedente installazione gestita dal Toolbox, la aggiorna senza disinstallarla.

Prima di iniziare, tieni presente che:

- il pacchetto è grande circa **138,1 MiB**;
- il download può richiedere diversi minuti, in base alla velocità della connessione;
- durante il download PowerShell può mostrare **“Scrittura richiesta Web”** oppure **“Scrittura del flusso di richiesta in corso...”**;
- questi messaggi sono normali e non significano che PowerShell si sia bloccato;
- **non chiudere PowerShell** e **non rilanciare il comando**;
- attendi fino a quando compare il messaggio **“Installazione completata.”**.

Segui questi passaggi:

1. Apri **Start**.
2. Cerca **PowerShell**.
3. Aprilo normalmente, senza scegliere l'avvio come amministratore.
4. Incolla questo comando:

```powershell
irm https://raw.githubusercontent.com/gregoriomangano/mg-windows-toolbox/main/install.ps1 | iex
```

5. Premi **Invio**.
6. Aspetta la fine senza chiudere PowerShell e senza inserire di nuovo il comando.
7. Cerca **M.G Windows Toolbox** nel menu Start quando compare **“Installazione completata.”**.

## Metodo manuale — Download del file ZIP

Se preferisci non usare PowerShell, segui i passaggi manuali qui sotto.

## PASSO 1 — Scarica

1. Apri la pagina **Releases** del repository M.G Windows Toolbox.
2. Apri la versione **M.G Windows Toolbox 0.3.0 Beta 5**.
3. Scorri fino alla sezione **Assets**.
4. Scarica `MG_Windows_Toolbox_0.3.0-beta.5_win64.zip`.

Se vuoi controllare che il download sia quello ufficiale, scarica anche `SHA256SUMS.txt`. Il valore SHA-256 è una specie di impronta del file: se non corrisponde, scarica di nuovo il pacchetto dalla release ufficiale.

## PASSO 2 — Apri la cartella

1. Vai nella cartella **Download**.
2. Trova il file ZIP appena scaricato.
3. Fai clic destro sul file e scegli **Estrai tutto...**.
4. Scegli una cartella facile da ritrovare, ad esempio Desktop o Documenti, poi premi **Estrai**.

Non avviare il programma direttamente dal file ZIP e non copiare soltanto l'EXE fuori dalla sua cartella.

## PASSO 3 — Avvia il programma

1. Apri la cartella estratta.
2. Apri `M.G Windows Toolbox-win32-x64`.
3. Fai doppio clic su `M.G Windows Toolbox.exe`.

All'apertura viene mostrata la Home. Il menu a sinistra porta alle varie aree del programma.

## PASSO 4 — Eventuale SmartScreen

La versione Beta non è firmata digitalmente. Windows può mostrare un messaggio SmartScreen anche se il file è quello corretto.

Se il download arriva dalla release ufficiale e hai verificato l'hash:

1. premi **Ulteriori informazioni**;
2. verifica che il nome sia `M.G Windows Toolbox.exe`;
3. premi **Esegui comunque**.

Non disattivare SmartScreen o Microsoft Defender. L'avviso serve a proteggere il PC da file sconosciuti; questa procedura riguarda esclusivamente il file ufficiale appena verificato.

## PASSO 5 — Prima schermata

La Home mostra una panoramica di CPU, memoria, disco e stato del PC. I dati possono richiedere qualche secondo per caricarsi. Usa il pulsante **Aggiorna dati** soltanto se vuoi rileggere le informazioni.

## PASSO 6 — Come usare il menu laterale

Nel menu a sinistra trovi le varie aree: App Center per i programmi, Pulizia per i file temporanei, Sicurezza per le protezioni Windows, Rete e DNS per la connessione, e così via.

Prima di usare un pulsante, leggi la breve spiegazione nella pagina. Per modifiche importanti il Toolbox mostra una conferma o indica se l'azione può essere ripristinata.

## PASSO 7 — Quando Windows chiede l'autorizzazione amministratore

Alcune funzioni cambiano impostazioni di sistema. In questi casi Windows può mostrare una finestra UAC con il pulsante **Sì** o **No**.

Conferma soltanto se hai appena scelto quella funzione nel Toolbox e ne hai letto la spiegazione. Se hai dubbi, scegli **No**: non verrà applicata alcuna modifica.

## Se qualcosa non funziona

### L'EXE non parte

Controlla di aver estratto tutto il file ZIP e di avviare l'EXE dalla cartella `M.G Windows Toolbox-win32-x64`. Non spostare l'EXE da solo.

### Compare SmartScreen

Leggi il PASSO 4. Controlla sempre di aver scaricato dalla release ufficiale e, se possibile, confronta il file con `SHA256SUMS.txt`.

### Il download sembra incompleto

Elimina il file ZIP incompleto, scaricalo di nuovo dalla pagina Releases e aspetta che il browser indichi la fine del download prima di estrarlo.

### WinGet non è disponibile o mostra un errore

Alcuni PC possono avere WinGet non aggiornato o non disponibile. Il Toolbox dovrebbe mostrare un messaggio comprensibile. In questo caso aggiorna Windows e riprova più tardi; non incollare comandi casuali trovati online.

### Una funzione richiede amministratore

È normale per operazioni su impostazioni Windows. Leggi il messaggio, poi approva UAC solo se riconosci l'azione scelta. Se annulli, l'operazione non viene completata.

## Collegamenti ufficiali

- YouTube: https://www.youtube.com/@GregorioMangano
- Sito: https://www.manganogregorio.it/
- Contatti: https://www.manganogregorio.it/#contatti
